From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Sat, 15 May 2010 15:03:39 -0500
Message-ID: <64.72.08602.22EFEEB4@cdptpa-omtalb.mail.rr.com>
References: <1273796172.5140.2068.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1273796172.5140.2068.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > It seems odd to me that all the raid volumes are named "Backup".
> > > Perhaps mdadm doesn't like the name collision.
> >
> > 	First of all, isn't that the homehost name?  If so, it is *SUPPOSED*
> > to be the same for all three.  Secondly, it assembled just fine under
> the
> > old kernel and mdadm, as I mentioned.  Thirdly, if it were the case, I
> would
> > expect it to assemble at least the first target without complaint.
> Finally,
> > the names aren't the same.  They are 'Backup':1, 'Backup':2, and
> 'Backup':3
> >
> Nope.  I suspect you've mistaken the mdadm option -N or --name for
> --hostname.
> 
> The name should be specific to the individual arrays and hostname is for
> saying these arrays belong to this host.

	Here it is in the man page:

[--homehost=
              This will override any HOMEHOST setting in the config file and
provides the identity of the host which should be considered the home for
any arrays.  When  creating an array, the homehost will be recorded in the
superblock.  For version-1 superblocks, it will be prefixed to the array
name...]

	Thus, the array names are 0, 1, 2, and 3, each prepended in the
superblock by 'Backup'.  Since I did not specify a name when I created the
arrays, presumably mdadm simply used the minor number as the array name.
Thus, /dev/md0 became 'Backup':0, /dev/md1 became 'Backup':1, etc.

	Also from the man page:

[-N, --name=
              Set  a  name for the array.  This is currently only effective
when creating an array with a version-1 superblock, or an array in a DDF
container.  The name is a simple textual string that can be used to identify
array components when assembling.  If name is needed but not specified, it
is taken  from the basename of the device that is being created.  e.g. when
creating /dev/md/home the name will default to home.]

	I cannot help but believe this persistent failure to assemble the
arrays in the initrd is related to the fact mdadm will not auto-assemble the
arrays from mdadm.conf when one issues the command:

`mdadm --assemble --scan`

	I have asked about this repeatedly in this forum, but have never
received any answer at all.  After all, isn't this effectively what mdadm
does when booting in order to attempt to bring up the arrays for mounting,
in particular the / array, which must be present in order to transfer OS
activity from the RAM disk to the hard drive?  I don't really know why it
worked under the old kernel - although it did issue a warning during the
boot process that it could not find any drives to assemble - but won't work
under the newer kernel.

	Neil, I know you are busy, but you have been awfully silent in all
of this.  Do you have any insights?

