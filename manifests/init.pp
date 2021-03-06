# == Class: druid
#
# Install and setup druid with all needed dependencies.
#
# === Parameters
#
# [*version*]
#   Version of druid to install.
#
#   Defaults to '0.8.1'.
#
# [*java_pkg*]
#   Name of the java package to ensure installed on system.
#
#   Defaults to 'openjdk-7-jre-headless'.
#
# [*install_dir*]
#   Directory druid will be installed in.
#
#   Defaults to '/usr/local/lib'.
#
# [*config_dir*]
#   Directory druid will keep configuration files.
#
#   Defaults to '/etc/druid'.
#
# [*extensions_remote_repositories*]
#   Array of remote repositories to load dependencies from.
# 
#   Defaults to `[
#     'http://repo1.maven.org/maven2/',
#     'https://metamx.artifactoryonline.com/metamx/pub-libs-releases-local',
#   ]`.
# 
# [*extensions_local_repository*]
#   The way maven gets dependencies is that it downloads them to a
#   "local repository" on your local disk and then collects the paths to each
#   of the jars. This specifies the directory to consider the "local
#   repository". If this is set, `extensions_remote_repositories` is not
#   required.
# 
#   Defaults to `'~/.m2/repository'`.
# 
# [*extensions_coordinates*]
#   Array of "groupId:artifactId[:version]" maven coordinates.
# 
#   Defaults to `[]`.
# 
# [*extensions_default_version*]
#   Version to use for extension artifacts without version information.
# 
# [*extensions_search_current_classloader*]
#   This is a boolean flag that determines if Druid will search the main
#   classloader for extensions. It defaults to true but can be turned off if
#   you have reason to not automatically add all modules on the classpath.
# 
#   Defaults to `true`.
# 
# [*zk_service_host*]
#   The ZooKeeper hosts to connect to.
#
#   Defaults to `'localhost'`.
# 
# [*zk_service_session_timeout_ms*]
#   ZooKeeper session timeout, in milliseconds.
# 
#   Defaults to `30000`.
# 
# [*curator_compress*]
#   Boolean flag for whether or not created Znodes should be compressed.
# 
#   Defaults to `true`.
# 
# [*zk_paths_base*]
#   Base Zookeeper path.
# 
#   Defaults to `'/druid'`.
# 
# [*zk_paths_properties_path*]
#   Zookeeper properties path.
# 
# [*zk_paths_announcements_path*]
#   Druid node announcement path.
# 
# [*zk_paths_live_segments_path*]
#   Current path for where Druid nodes announce their segments.
# 
# [*zk_paths_load_queue_path*]
#   Entries here cause historical nodes to load and drop segments.
# 
# [*zk_paths_coordinator_path*]
#   Used by the coordinator for leader election.
# 
# [*zk_paths_indexer_base*]
#   Base zookeeper path for indexers.
# 
# [*zk_paths_indexer_announcements_path*]
#   Middle managers announce themselves here.
# 
# [*zk_paths_indexer_tasks_path*]
#   Used to assign tasks to middle managers.
# 
# [*zk_paths_indexer_status_path*]
#   Parent path for announcement of task statuses.
# 
# [*zk_paths_indexer_leader_latch_path*]
#   Used for Overlord leader election.
# 
# [*discovery_curator_path*]
#   Services announce themselves under this ZooKeeper path.
# 
#   Defaults to `'/druid/discovery'`.
# 
# [*request_logging_type*]
#   Specifies the type of logging used.
# 
#   Valid values: `'noop'`, `'file'`, `'emitter'`.
# 
#   Defaults to `'noop'`.
# 
# [*request_logging_dir*]
#   Historical, Realtime and Broker nodes maintain request logs of all of the
#   requests they get (interacton is via POST, so normal request logs don’t
#   generally capture information about the actual query), this specifies the
#   directory to store the request logs in
# 
#   Defaults to `''`.
# 
# [*request_logging_feed*]
#   Feed name for requests.
# 
#   Defaults to `'druid'`.
# 
# [*monitoring_emission_period*]
#   How often metrics are emitted.
# 
#   Defaults to `'PT1m'`.
# 
# [*monitoring_monitors*]
#   Array of Druid monitors used by a node. See below for names and more
#   information.
# 
#   Valid array values are:
#     `'io.druid.client.cache.CacheMonitor'`:
#       Emits metrics (to logs) about the segment results cache for Historical
#       and Broker nodes. Reports typical cache statistics include hits,
#       misses, rates, and size (bytes and number of entries), as well as
#       timeouts and and errors.
#     `'com.metamx.metrics.SysMonitor'`:
#       This uses the SIGAR library to report on various system activities
#       and statuses. Make sure to add the sigar library jar to your classpath
#       if using this monitor.
#     `'io.druid.server.metrics.HistoricalMetricsMonitor'`:
#       Reports statistics on Historical nodes.
#     `'com.metamx.metrics.JvmMonitor'`:
#       Reports JVM-related statistics.
#     `'io.druid.segment.realtime.RealtimeMetricsMonitor'`:
#       Reports statistics on Realtime nodes.
# 
#   Defaults to `[]`.
# 
# [*emitter*]
#   Emitter module to use.
# 
#   Valid values are: `'noop'`, `'logging'`, or `'http'`.
# 
#   Defaults to `'logging'`.
# 
# [*emitter_logging_logger_class*]
#   The class used for logging.
# 
#   Valid values are: `'HttpPostEmitter'`, `'LoggingEmitter'`,
#   `'NoopServiceEmitter'`, or `'ServiceEmitter'`
# 
#   Defaults to `'LoggingEmitter'`.
# 
# [*emitter_logging_log_level*]
#   The log level at which message are logged.
# 
#   Valid values are: `'debug'`, `'info'`, `'warn'`, or `'error'`
# 
#   Defaults to `'info'`.
# 
# [*emitter_http_time_out*]
#   The timeout for data reads.
#
#   Defaults to `'PT5M'`.
# 
# [*emitter_http_flush_millis*]
#   How often to internal message buffer is flushed (data is sent).
#
#   Defaults to `60000`.
# 
# [*emitter_http_flush_count*]
#   How many messages can the internal message buffer hold before flushing
#   (sending).
# 
#   Defaults to `500`.
# 
# [*emitter_http_recipient_base_url*]
#   The base URL to emit messages to. Druid will POST JSON to be consumed at
#   the HTTP endpoint specified by this property.
# 
#   Defaults to `''`.
# 
# [*metadata_storage_type*]
#   The type of metadata storage to use.
# 
#   Valid values are: `'mysql'`, `'postgres'`, or `'derby'`
# 
#   Defaults to `'mysql'`.
# 
# [*metadata_storage_connector_uri*]
#   The URI for the metadata storage.
#
#   Defaults to `'jdbc:mysql://localhost:3306/druid?characterEncoding=UTF-8'`
#
# [*metadata_storage_connector_user*]
#   The username to connect to the metadata storage with.
#
#   Defaults to `'druid'`.
# 
# [*metadata_storage_connector_password*]
#   The password to connect with.
#
#   Defaults to `'insecure_pass'`.
# 
# [*metadata_storage_connector_create_tables*]
#   Specifies to create tables in the metadata storage if they do not exits.
# 
#   Defaults to `true`.
# 
# [*metadata_storage_tables_base*]
#   The base name for tables.
# 
#   Defaults to `'druid'`.
# 
# [*metadata_storage_tables_segment_table*]
#   The table to use to look for segments.
# 
#   Defaults to `'druid_segments'`.
# 
# [*metadata_storage_tables_rule_table*]
#   The table to use to look for segment load/drop rules.
# 
#   Defaults to `'druid_rules'`.
# 
# [*metadata_storage_tables_config_table*]
#   The table to use to look for configs.
# 
#   Defaults to `'druid_config'`.
# 
# [*metadata_storage_tables_tasks*]
#   The table used by the indexing service to store tasks.
# 
#   Defaults to `'druid_tasks'`.
# 
# [*metadata_storage_tables_task_log*]
#   Used by the indexing service to store task logs.
# 
#   Defaults to `'druid_taskLog'`.
# 
# [*metadata_storage_tables_task_lock*]
#   Used by the indexing service to store task locks.
# 
#   Defaults to `'druid_taskLock'`.
# 
# [*metadata_storage_tables_audit*]
#   The table to use for audit history of configuration changes.
# 
#   Defaults to `'druid_audit'`.
# 
# [*storage_type*]
#   The type of deep storage to use.
# 
#   Valid values are: `'local'`, `'noop'`, `'s3'`, `'hdfs'`, or `'c*'` 
# 
#   Defaults to `'local'`.
# 
# [*storage_directory*]
#   Directory on disk to use as deep storage if `$storage_type` is set to
#   `'local'`.
# 
#   Defaults to `'/tmp/druid/localStorage'`.
# 
# [*s3_access_key*]
#   The access key to use to access S3.
# 
# [*s3_secret_key*]
#   The secret key to use to access S3.
# 
# [*s3_bucket*]
#   S3 bucket name.
# 
# [*s3_base_key*]
#   S3 object key prefix for storage.
# 
# [*storage_disable_acl*]
#   Boolean flag for ACL.
# 
#   Defaults to `false`.
# 
# [*s3_archive_bucket*]
#   S3 bucket name for archiving when running the indexing-service archive task.
# 
# [*s3_archive_base_key*]
#   S3 object key prefix for archiving.
# 
# [*hdfs_directory*]
#   HDFS directory to use as deep storage.
# 
# [*cassandra_host*]
#   Cassandra host to access for deep storage.
# 
# [*cassandra_keyspace*]
#   Cassandra key space.
# 
# [*cache_type*]
#   The type of cache to use for queries.
# 
#   Valid values: `'local'` or `'memcached'`.
# 
#   Defaults to `'local'`.
# 
# [*cache_uncacheable*]
#   All query types to not cache.
# 
# [*cache_size_in_bytes*]
#   Maximum local cache size in bytes. Zero disables caching.
# 
#   Defaults to `0`.
# 
# [*cache_initial_size*]
#   Initial size of the hashtable backing the local cache.
# 
#   Defaults to `500000`.
# 
# [*cache_log_eviction_count*]
#   If non-zero, log local cache eviction for that many items.
# 
#   Defaults to `0`.
# 
# [*cache_expiration*]
#   Memcached expiration time.
# 
#   Defaults to `2592000` (30 days).
# 
# [*cache_timeout*]
#   Maximum time in milliseconds to wait for a response from Memcached.
# 
#   Defaults to `500`.
# 
# [*cache_hosts*]
#   Array of Memcached hosts (`'host:port'`).
# 
#   Defaults to `[]`.
# 
# [*cache_max_object_size*]
#   Maximum object size in bytes for a Memcached object.
# 
#   Defaults to `52428800` (50 MB).
# 
# [*cache_memcached_prefix*]
#   Key prefix for all keys in Memcached.
# 
#   Defaults to `'druid'`.
# 
# [*selectors_indexing_service_name*]
#   The service name of the indexing service Overlord node. To start the
#   Overlord with a different name, set it with this property.
# 
#   Defaults to `'druid/overlord'`.
# 
# [*announcer_type*]
#   The type of data segment announcer to use.
# 
#   Valid values are: `'legacy'` or `'batch'`.
# 
#   Defaults to `'batch'`.
# 
# [*announcer_segments_per_node*]
#   Each Znode contains info for up to this many segments.
# 
#   Defaults to `50`.
# 
# [*announcer_max_bytes_per_node*]
#   Max byte size for Znode.
# 
#   Defaults to `524288`.
#
# === Examples
#
#  class { 'druid': 
#    version     => '0.8.0',
#    java_pkg    => 'openjdk-7-jre-headless',
#    install_dir => '/usr/local/lib',
#    config_dir  => '/etc/druid',
#  }
#
# === Authors
#
# Tyler Yahn <codingalias@gmail.com>
#
class druid (
  $version                                  = $druid::params::version,
  $nstall_java                              = $druid::params::install_java,
  $install_dir                              = $druid::params::install_dir,
  $config_dir                               = $druid::params::config_dir,
  $extra_classpaths                         = $druid::params::extra_classpaths,
  $extensions_remote_repositories           = $druid::params::extensions_remote_repositories,
  $extensions_local_repository              = $druid::params::extensions_local_repository,
  $extensions_coordinates                   = $druid::params::extensions_coordinates,
  $extensions_default_version               = $druid::params::extensions_default_version,
  $extensions_search_current_classloader    = $druid::params::extensions_search_current_classloader,
  $zk_service_host                          = $druid::params::zk_service_host,
  $zk_service_session_timeout_ms            = $druid::params::zk_service_session_timeout_ms,
  $curator_compress                         = $druid::params::curator_compress,
  $zk_paths_base                            = $druid::params::zk_paths_base,
  $zk_paths_properties_path                 = $druid::params::zk_paths_properties_path,
  $zk_paths_announcements_path              = $druid::params::zk_paths_announcements_path,
  $zk_paths_live_segments_path              = $druid::params::zk_paths_live_segments_path,
  $zk_paths_load_queue_path                 = $druid::params::zk_paths_load_queue_path,
  $zk_paths_coordinator_path                = $druid::params::zk_paths_coordinator_path,
  $zk_paths_indexer_base                    = $druid::params::zk_paths_indexer_base,
  $zk_paths_indexer_announcements_path      = $druid::params::zk_paths_indexer_announcements_path,
  $zk_paths_indexer_tasks_path              = $druid::params::zk_paths_indexer_tasks_path,
  $zk_paths_indexer_status_path             = $druid::params::zk_paths_indexer_status_path,
  $zk_paths_indexer_leader_latch_path       = $druid::params::zk_paths_indexer_leader_latch_path,
  $discovery_curator_path                   = $druid::params::discovery_curator_path,
  $request_logging_type                     = $druid::params::request_logging_type,
  $request_logging_dir                      = $druid::params::request_logging_dir,
  $request_logging_feed                     = $druid::params::request_logging_feed,
  $monitoring_emission_period               = $druid::params::monitoring_emission_period,
  $monitoring_monitors                      = $druid::params::monitoring_monitors,
  $emitter                                  = $druid::params::emitter,
  $emitter_logging_logger_class             = $druid::params::emitter_logging_logger_class,
  $emitter_logging_log_level                = $druid::params::emitter_logging_log_level,
  $emitter_http_time_out                    = $druid::params::emitter_http_time_out,
  $emitter_http_flush_millis                = $druid::params::emitter_http_flush_millis,
  $emitter_http_flush_count                 = $druid::params::emitter_http_flush_count,
  $emitter_http_recipient_base_url          = $druid::params::emitter_http_recipient_base_url,
  $metadata_storage_type                    = $druid::params::metadata_storage_type,
  $metadata_storage_connector_uri           = $druid::params::metadata_storage_connector_uri,
  $metadata_storage_connector_user          = $druid::params::metadata_storage_connector_user,
  $metadata_storage_connector_password      = $druid::params::metadata_storage_connector_password,
  $metadata_storage_connector_create_tables = $druid::params::metadata_storage_connector_create_tables,
  $metadata_storage_tables_base             = $druid::params::metadata_storage_tables_base,
  $metadata_storage_tables_segment_table    = $druid::params::metadata_storage_tables_segment_table,
  $metadata_storage_tables_rule_table       = $druid::params::metadata_storage_tables_rule_table,
  $metadata_storage_tables_config_table     = $druid::params::metadata_storage_tables_config_table,
  $metadata_storage_tables_tasks            = $druid::params::metadata_storage_tables_tasks,
  $metadata_storage_tables_task_log         = $druid::params::metadata_storage_tables_task_log,
  $metadata_storage_tables_task_lock        = $druid::params::metadata_storage_tables_task_lock,
  $metadata_storage_tables_audit            = $druid::params::metadata_storage_tables_audit,
  $storage_type                             = $druid::params::storage_type,
  $storage_directory                        = $druid::params::storage_directory,
  $s3_access_key                            = $druid::params::s3_access_key,
  $s3_secret_key                            = $druid::params::s3_secret_key,
  $s3_bucket                                = $druid::params::s3_bucket,
  $s3_base_key                              = $druid::params::s3_base_key,
  $storage_disable_acl                      = $druid::params::storage_disable_acl,
  $s3_archive_bucket                        = $druid::params::s3_archive_bucket,
  $s3_archive_base_key                      = $druid::params::s3_archive_base_key,
  $hdfs_directory                           = $druid::params::hdfs_directory,
  $cassandra_host                           = $druid::params::cassandra_host,
  $cassandra_keyspace                       = $druid::params::cassandra_keyspace,
  $cache_type                               = $druid::params::cache_type,
  $cache_uncacheable                        = $druid::params::cache_uncacheable,
  $cache_size_in_bytes                      = $druid::params::cache_size_in_bytes,
  $cache_initial_size                       = $druid::params::cache_initial_size,
  $cache_log_eviction_count                 = $druid::params::cache_log_eviction_count,
  $cache_expiration                         = $druid::params::cache_expiration,
  $cache_timeout                            = $druid::params::cache_timeout,
  $cache_hosts                              = $druid::params::cache_hosts,
  $cache_max_object_size                    = $druid::params::cache_max_object_size,
  $cache_memcached_prefix                   = $druid::params::cache_memcached_prefix,
  $selectors_indexing_service_name          = $druid::params::selectors_indexing_service_name,
  $announcer_type                           = $druid::params::announcer_type,
  $announcer_segments_per_node              = $druid::params::announcer_segments_per_node,
  $announcer_max_bytes_per_node             = $druid::params::announcer_max_bytes_per_node,
) inherits druid::params {
  validate_string(
    $extensions_local_repository,
    $zk_service_host,
    $zk_paths_base,
    $zk_paths_properties_path,
    $zk_paths_announcements_path,
    $zk_paths_live_segments_path,
    $zk_paths_load_queue_path,
    $zk_paths_coordinator_path,
    $zk_paths_indexer_base,
    $zk_paths_indexer_announcements_path,
    $zk_paths_indexer_tasks_path,
    $zk_paths_indexer_status_path,
    $zk_paths_indexer_leader_latch_path,
    $discovery_curator_path,
    $request_logging_dir,
    $request_logging_feed,
    $monitoring_emission_period,
    $emitter,
    $emitter_http_time_out,
    $emitter_http_recipient_base_url,
    $metadata_storage_connector_user,
    $metadata_storage_connector_password,
    $metadata_storage_tables_base,
    $metadata_storage_tables_segment_table,
    $metadata_storage_tables_rule_table,
    $metadata_storage_tables_config_table,
    $metadata_storage_tables_tasks,
    $metadata_storage_tables_task_log,
    $metadata_storage_tables_task_lock,
    $metadata_storage_tables_audit,
    $s3_access_key,
    $s3_secret_key,
    $s3_bucket,
    $s3_base_key,
    $s3_archive_bucket,
    $s3_archive_base_key,
    $hdfs_directory,
    $cassandra_host,
    $cassandra_keyspace,
    $cache_type,
    $cache_uncacheable,
    $cache_memcached_prefix,
    $selectors_indexing_service_name,
  )

  validate_array(
    $extensions_remote_repositories,
    $extensions_coordinates,
    $monitoring_monitors,
    $cache_hosts,
  )

  validate_bool(
    $install_java,
    $extensions_search_current_classloader,
    $curator_compress,
    $metadata_storage_connector_create_tables,
    $storage_disable_acl,
  )

  validate_integer($zk_service_session_timeout_ms)
  validate_integer($emitter_http_flush_millis)
  validate_integer($emitter_http_flush_count)
  validate_integer($cache_size_in_bytes)
  validate_integer($cache_initial_size)
  validate_integer($cache_log_eviction_count)
  validate_integer($cache_expiration)
  validate_integer($cache_timeout)
  validate_integer($cache_max_object_size)
  validate_integer($announcer_segments_per_node)
  validate_integer($announcer_max_bytes_per_node)

  validate_absolute_path($install_dir, $config_dir, $storage_directory)

  validate_re($version, '^([0-9]+)\.([0-9]+)\.([0-9]+)$')
  validate_re($request_logging_type, ['^noop$', '^file$', '^emitter$'])
  validate_re($storage_type, ['^local$', '^noop$', '^s3$', '^hdfs$', '^c$'])
  validate_re($metadata_storage_type, ['mysql', 'postgres', 'derby'])
  validate_re($announcer_type, ['^lecagy$', '^batch$'])
  validate_re($emitter_logging_logger_class, [
    '^HttpPostEmitter$',
    '^LoggingEmitter$',
    '^NoopServiceEmitter$',
    '^ServiceEmitter$',
  ])
  validate_re($emitter_logging_log_level, [
    '^debug$',
    '^info$',
    '^warn$',
    '^erro$',
  ])

  if $install_java {
    require ::oracle_java
  }

  $url = "http://static.druid.io/artifacts/releases/druid-${version}-bin.tar.gz"
  archive { "/var/tmp/druid-${version}-bin.tar.gz":
    ensure          => present,
    extract         => true,
    extract_path    => $install_dir,
    source          => $url,
    checksum_verify => false,
    creates         => "${install_dir}/druid-${version}",
    cleanup         => true,
  }
  -> file { "${install_dir}/druid":
    ensure  => link,
    target  => "${install_dir}/druid-${version}",
  }

  file { $config_dir:
    ensure  => directory,
  }

  file { "${config_dir}/common.runtime.properties":
    ensure  => file,
    content => template("${module_name}/common.runtime.properties.erb"),
    require => File[$config_dir],
  }
}
