From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Wed, 1 Mar 2017 17:20:07 -0500
Message-ID: <b1ff7027-57f7-9e76-9209-545681aed427@turmel.org>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
 <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
 <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
 <58B2137B.6070608@youngman.org.uk>
 <5172e2ab-e193-477b-52c4-86fbab0d52fe@turmel.org>
 <58B21987.6060604@youngman.org.uk>
 <657e80e9-b1f5-1f58-a4d0-6cbc4cc44927@turmel.org>
 <58B6E287.9020804@youngman.org.uk>
 <27373f29-a8ea-012c-102d-9fadf05cb3c2@turmel.org>
 <2d168cc1-cddc-5e0c-610b-97cbd08de621@turmel.org>
 <f14b00ef-17bd-d9ee-6153-2e92b0ce11ae@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f14b00ef-17bd-d9ee-6153-2e92b0ce11ae@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2017 02:50 PM, Anthony Youngman wrote:

> Because - and this is a point the kernel guys seem to forget - the
> whole point of having a computer system is TO RUN APPLICATIONS, not
> to run an OS.

If I were a kernel guy, I might be offended.  They run applications,
too, ya know.

> It's all very well saying lvm was created with this in mind, but if
> the system wasn't installed with this originally in mind, you're up a
> gum tree. My home system is raid but not lvm, for example - how do I
> back up the system while it's live? (In reality, I don't care :-)

This little tidbit would have helped.  If you can't redesign your system
to make consistent backups while running, you have to shut down to make
consistent backups.  Tautology, there.  I was arguing from the
assumption that you weren't too far gone to help.

It seems to me that if you can shut it down to make a consistent backup,
you can shut it down to re-jigger the device layering.  Possibly faster
to do that than take the backup, if you are willing take a small risk.

If you are using a database technology that supports checkpointed
backups while running, like PostgreSQL[1], you might get the backup you
need without downtime.  But fixing the device layering issue is what you
should do, imnsho.  Not taking a backup isn't really an option.

1) Create another raid, possibly degraded, and set it up as a PV in a
new volume group.

2) Stop your database and unmount home long enough to resize your
filesystem as small as practical, at least so it fits in an LV in the
new volume group with some free space for future snapshots.

3) Create an LV in the new VG big enough to hold that FS and dd it over.

4) If you need to, break redundant devices out of /dev/md/home to add to
the new array.  When you have the new raid to a comfortable level of
redundancy, mount the LV as /home and resume operations.

5) Finish breaking down the previous array and possibly using its
devices to bolster the redundancy on the new array.

If you are feeling brave, you could use --build mode instead of (3) to
resume running on /dev/md/builthome (comprised of the shrunk
/dev/md/home and the LV) instead of using dd.  When the resync is done,
you'd take a second short outage to unmount /dev/md/builthome and mount
/dev/vg0/home.

Phil

[1] https://www.postgresql.org/docs/9.5/static/continuous-archiving.html

(See the pg_basebackup utility and the description of the API it uses.)
