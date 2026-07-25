-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "devops_cli";

-- CreateTable
CREATE TABLE "devops_cli"."categories" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "icon" VARCHAR(100),
    "color" VARCHAR(10),
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "devops_cli"."commands" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "command_template" TEXT NOT NULL,
    "category" VARCHAR(100) NOT NULL,
    "tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "example" TEXT,
    "syntax_help" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "commands_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "devops_cli"."command_properties" (
    "id" SERIAL NOT NULL,
    "command_id" INTEGER NOT NULL,
    "property_name" VARCHAR(100) NOT NULL,
    "property_type" VARCHAR(50) NOT NULL,
    "default_value" TEXT,
    "is_required" BOOLEAN NOT NULL DEFAULT false,
    "placeholder" TEXT,
    "description" VARCHAR(255),
    "select_options" JSONB,
    "validation_pattern" VARCHAR(255),
    "display_order" INTEGER,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "command_properties_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "devops_cli"."command_templates" (
    "id" SERIAL NOT NULL,
    "command_id" INTEGER NOT NULL,
    "template_name" VARCHAR(255) NOT NULL,
    "property_values" JSONB NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "command_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "devops_cli"."copy_history" (
    "id" SERIAL NOT NULL,
    "command_id" INTEGER NOT NULL,
    "command_template_id" INTEGER,
    "copied_command" TEXT NOT NULL,
    "property_values" JSONB,
    "copied_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "copy_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "devops_cli"."feature_requests" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT NOT NULL,
    "command_example" TEXT,
    "category" VARCHAR(100),
    "priority" VARCHAR(50) NOT NULL DEFAULT 'medium',
    "status" VARCHAR(50) NOT NULL DEFAULT 'pending',
    "votes_up" INTEGER NOT NULL DEFAULT 0,
    "votes_down" INTEGER NOT NULL DEFAULT 0,
    "notes" TEXT,
    "requested_by" VARCHAR(100) NOT NULL DEFAULT 'anonymous',
    "requested_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "feature_requests_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "categories_name_key" ON "devops_cli"."categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "commands_name_key" ON "devops_cli"."commands"("name");

-- CreateIndex
CREATE INDEX "idx_commands_category" ON "devops_cli"."commands"("category");

-- CreateIndex
CREATE INDEX "idx_commands_tags" ON "devops_cli"."commands" USING GIN ("tags");

-- CreateIndex
CREATE INDEX "idx_commands_name" ON "devops_cli"."commands"("name");

-- CreateIndex
CREATE INDEX "idx_command_properties_command_id" ON "devops_cli"."command_properties"("command_id");

-- CreateIndex
CREATE UNIQUE INDEX "command_properties_command_id_property_name_key" ON "devops_cli"."command_properties"("command_id", "property_name");

-- CreateIndex
CREATE INDEX "idx_copy_history_created_at" ON "devops_cli"."copy_history"("copied_at");

-- CreateIndex
CREATE INDEX "idx_copy_history_command_id" ON "devops_cli"."copy_history"("command_id");

-- CreateIndex
CREATE INDEX "idx_feature_requests_status" ON "devops_cli"."feature_requests"("status");

-- CreateIndex
CREATE INDEX "idx_feature_requests_category" ON "devops_cli"."feature_requests"("category");

-- CreateIndex
CREATE INDEX "idx_feature_requests_votes" ON "devops_cli"."feature_requests"("votes_up" DESC);

-- AddForeignKey
ALTER TABLE "devops_cli"."commands" ADD CONSTRAINT "commands_category_fkey" FOREIGN KEY ("category") REFERENCES "devops_cli"."categories"("name") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "devops_cli"."command_properties" ADD CONSTRAINT "command_properties_command_id_fkey" FOREIGN KEY ("command_id") REFERENCES "devops_cli"."commands"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "devops_cli"."command_templates" ADD CONSTRAINT "command_templates_command_id_fkey" FOREIGN KEY ("command_id") REFERENCES "devops_cli"."commands"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "devops_cli"."copy_history" ADD CONSTRAINT "copy_history_command_id_fkey" FOREIGN KEY ("command_id") REFERENCES "devops_cli"."commands"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "devops_cli"."copy_history" ADD CONSTRAINT "copy_history_command_template_id_fkey" FOREIGN KEY ("command_template_id") REFERENCES "devops_cli"."command_templates"("id") ON DELETE SET NULL ON UPDATE CASCADE;

