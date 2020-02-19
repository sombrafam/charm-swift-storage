# Overview

OpenStack [Swift][swift-upstream] is a highly available, distributed,
eventually consistent object/blob store.

The swift-storage charm deploys Swift's storage component. The charm's basic
function is to initialise storage devices and manage the container, object, and
account services. It works in tandem with the [swift-proxy][swift-proxy-charm]
charm, which is used to add proxy nodes.

# Usage

## Configuration

This section covers common configuration options. See file `config.yaml` for
the full list of options, along with their descriptions and default values.

### `zone`

The `zone` option assigns a storage zone (an integer) to a storage node. A zone
is associated with data replicas.

### `block-device`

The `block-device` option specifies the device(s) that will be used on all
machines associated with the application. Value types include:

* an actual block device (e.g. 'sdb' or '/dev/sdb'). A space-separated list is
  used for multiple devices.
* a path to a local file with the size appended after a pipe (e.g.
  '/etc/swift/storagedev1.img|5G'). The file will be created if necessary and
  be mapped to a loopback device. This is intended for development and testing
  purposes.

The resulting block device(s) will be XFS-formatted and use
`/srv/node/<device-name>` as a mount point.

### `storage-region`

The `storage-region` option specifies a storage region (an integer). It is used
only for multi-region (global) clusters.

## Deployment

Let file ``swift.yaml`` contain the deployment configuration:

```yaml
    swift-proxy:
        zone-assignment: manual
        replicas: 3
    swift-storage-zone1:
        zone: 1
        block-device: /dev/sdb
    swift-storage-zone2:
        zone: 2
        block-device: /dev/sdb
    swift-storage-zone3:
        zone: 3
        block-device: /dev/sdb
```

Deploy the proxy and storage nodes:

    juju deploy --config swift.yaml swift-proxy
    juju deploy --config swift.yaml swift-storage swift-storage-zone1
    juju deploy --config swift.yaml swift-storage swift-storage-zone2
    juju deploy --config swift.yaml swift-storage swift-storage-zone3

Add relations between the proxy node and all storage nodes:

    juju add-relation swift-proxy:swift-storage swift-storage-zone1:swift-storage
    juju add-relation swift-proxy:swift-storage swift-storage-zone2:swift-storage
    juju add-relation swift-proxy:swift-storage swift-storage-zone3:swift-storage

This will result in a three-zone cluster, with each zone consisting of a single
storage node, thereby satisfying the replica requirement of three.

Storage capacity is increased by adding swift-storage units to a zone. For
example, to add two storage nodes to zone '3':

    juju add-unit -n 2 swift-storage-zone3

> **Note**: When scaling out ensure the candidate machines are equipped with
  the block devices currently configured for the associated application.

This charm will not balance the storage ring until there are enough storage
zones to meet its minimum replica requirement, in this case three.

Appendix [Swift usage][cdg-app-swift] in the [OpenStack Charms Deployment
Guide][cdg] offers in-depth guidance for deploying Swift with charms. In
particular, it shows how to set up a multi-region (global) cluster.

## Actions

This section covers Juju [actions][juju-docs-actions] supported by the charm.
Actions allow specific operations to be performed on a per-unit basis.

* `openstack-upgrade`
* `pause`
* `resume`

To display action descriptions run `juju actions swift-storage`.

# Bugs

Please report bugs on [Launchpad][lp-bugs-charm-swift-storage].

For general charm questions refer to the [OpenStack Charm Guide][cg].

<!-- LINKS -->

[cg]: https://docs.openstack.org/charm-guide
[cdg]: https://docs.openstack.org/project-deploy-guide/charm-deployment-guide
[cdg-app-swift]: https://docs.openstack.org/project-deploy-guide/charm-deployment-guide/latest/app-swift.html
[swift-proxy-charm]: https://jaas.ai/swift-proxy
[swift-proxy-charm-readme]: https://opendev.org/openstack/charm-swift-proxy/src/branch/master/README.md
[swift-upstream]: https://docs.openstack.org/developer/swift
[lp-bugs-charm-swift-storage]: https://bugs.launchpad.net/charm-swift-storage/+filebug
[juju-docs-actions]: https://jaas.ai/docs/actions
