Overview
--------

This charm provides the swift-storage component of the OpenStack Swift object
storage system.  It can be deployed as part of its own standalone storage
cluster or it can be integrated with the other OpenStack components, assuming
those are also managed by Juju.  For Swift to function, you'll also need to
deploy an additional swift-proxy using the cs:precise/swift-proxy charm.

For more information about Swift and its architecture, visit the official
[Swift project website][swift-project].

This charm is intended to track each LTS release of Ubuntu Server, as well as
newer OpenStack releases via the Ubuntu Cloud Archive as supported by each
Ubuntu LTS version.  Non-LTS (interim release) Ubuntu server versions are
enabled in the charms strictly for development and testing purposes.

Usage
-----

This charm is quite simple.  Its basic function is to get a storage device
setup for swift usage, and run the container, object and account services.
The deployment workflow for swift using this charm is covered in the README
for the swift-proxy charm at cs:precise/swift-proxy.  The following are
deployment options to take into consideration when deploying swift-storage.

**Zone assignment**

If the swift-proxy charm is configured for manual zone assignment (recommended),
the 'zone' option should be set for each swift-storage service being deployed.
See the swift-proxy README for more information about zone assignment.

**Region assignment**

If the swift-proxy charm is configured with the Swift Global Cluster feature,
the 'region' option should be set for each swift-storage service being deployed.
See the [swift-proxy charm README][swift-proxy-charm-readme] for more information
about the Swift Global Cluster feature.

**Storage**

Swift storage nodes require access to local storage and filesystem.  The charm
takes a 'block-device' config setting that can be used to specify which storage
device(s) to use.  Options include:

 - 1 or more local block devices (eg, sdb or /dev/sdb).  It's important that this
   device be the same on all machine units assigned to this service.  Multiple
   block devices should be listed as a space-separated list of device nodes.
 - a path to a local file on the filesystem with the size appended after a pipe,
   eg "/etc/swift/storagedev1.img|5G".  This will be created if it does not
   exist and be mapped to a loopback device. Intended strictly for development
   and testing.
 - "guess" can be used to tell the charm to do its best to find a local devices
   to use. *EXPERIMENTAL*

Multiple devices can be specified. In all cases, the resulting block device(s)
will each be formatted as XFS file system and mounted at /srv/node/$devname.

**Installation repository**

The 'openstack-origin' setting allows Swift to be installed from repositories
such as the Ubuntu Cloud Archive, which enables installation of Swift versions
more recent than what shipped with the Ubuntu LTS release.  For more
information, see config.yaml.

[swift-proxy-charm-readme]: https://opendev.org/openstack/charm-swift-proxy/src/branch/master/README.md
[swift-project]: https://docs.openstack.org/developer/swift