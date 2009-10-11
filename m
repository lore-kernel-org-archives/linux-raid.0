From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: NAS Remote Side of a Mirror
Date: Sun, 11 Oct 2009 02:00:58 -0500
Message-ID: <20091011070101798.ROTW14562@cdptpa-omta03.mail.rr.com>
References: <39822.52296.qm@web38802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <39822.52296.qm@web38802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'adfas asd' <chimera_god@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> --- On Sat, 10/10/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> >     I'm not familiar with NX.  Why not
> > X11?
> 
> I tried to set up remote X a long time ago, but it was just too
> problematic.  NX does essentially the same thing, and has built-in
> security. (nomachine.com)  Works great, and is very fast.

	X11 is not overly slow, and I have never had any really significant
problems with it.  I've been using it on a large number of systems across
several platforms for over 15 years.  Of course, no system is completely
free of issues, but X11 on *nix platforms has presented me with very few.

	I'm relatively new to Linux, but I've had few problems setting up
X11 on any Linux platform, and none at all once I have it set up.  I'm
running X11 on several Debian platforms here in my house.  For X-server
access via Windows workstations, I use X-Ming.  For access via one of the
Linux servers, I just ssh to the remote and start whatever X-Client I want.
KDM (which I like) also allows simple XDMCP support, although I never use
it.

> > > I'm not about to use bloatware like NFS or Samba. And
> > sshfs or an SSH
> > > tunnel could not keep up the speeds I'd need. How do
> > you suppose Qnap
> >
> >     Why do you say that?  From what I
> > have seen of your requirements, it
> > doesn't sound like you will require very much at all in the
> > way of speed on
> > your array.
> 
> Why do I say that?  Because they -are- bloatware, and an unnecessary fat
> layer in the system, with all the potential for error and security breach
> that implies.  iSCSI is the way, in the 21st century.

	That's not what I asked.  Why do you say (or think) you will need
much in the way of speed?  I didn't ask you anything about SAMBA or NFS.  I
use both, as it happens, on several of my servers, but I don't use either to
backup the Video Server.  I do have a NFS export from my Backup Server to
the Video Server just for convenience.  I certainly agree iSCSI is a good
choice for creating remote member disks on a RAID array.  Indeed it is
probably what I would use if I were creating an array with remote members,
but I am unconvinced this will be the best solution for you given what you
have told us about your requirements.  Of course, you know your requirements
better than we.

> >     Speaking of which, I never did see where
> > you posted the results of
> > any drive access metrics.
> 
> I'm sure I mentioned these are the WD 2TB drives.  Straight read 77.7MB/s
> in RAID10offset.

	Again, that's not what I asked.  I didn't ask you for drive
specifications or benchmark performance.  I asked you for drive access
metrics.  Under heavy load conditions with your software mix, how much read
and write bandwidth is being used, particularly once you separate off the
SQL database on a separate drive system from the main array?

	BTW, while a straight read of ~80 Mbps is not blazingly fast, it's
vastly more than you need strictly for video streams.  Real-time 1080i video
is generally less than 2 MB/s.  A read rate of more than 70 MB/s can easily
handle more than 20 HD streams in real time, and I doubt you are going to
handle more than 20 simultaneous streams.  Commercial tagging can of course
eat up considerably more bandwidth than real-time streams, but you are
complaining of response problems when doing commercial tagging, which would
rather suggest you aren't stressing the drive subsystems.  The only way to
know for certain, however is to actually measure the drive load when the
application is running.  For example, while on straight reads I can
sometimes peak above 100 MB/s with continuous rates above 90 MB/s, this is
what I see during a commercial scan:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.43    0.00    8.74    0.49    0.00   88.35

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda               9.00         1.42         0.34          1          0
sdb              11.00         1.52         0.26          1          0
sdc              11.00         1.27         0.42          1          0
sdd              10.00         1.27         0.50          1          0
sde              11.00         1.52         0.50          1          0
sdf              11.00         1.52         0.50          1          0
sdg              12.00         1.27         0.76          1          0
sdh              10.00         1.25         0.76          1          0
sdi              10.00         1.26         0.76          1          0
sdj              10.00         1.26         0.76          1          0
hda               5.00         0.00         0.09          0          0
hda1              0.00         0.00         0.00          0          0
hda2              3.00         0.00         0.08          0          0
hda3              0.00         0.00         0.00          0          0
hda4              2.00         0.00         0.01          0          0
hda5              0.00         0.00         0.00          0          0
md0             198.00        12.00         4.02         12          4

	There was also a 30 Mbps ftp session writing to disk from a TiVo,
which is why you see the non-zero write metrics.  That's a far cry from more
than 70 MB/s, is the point, though.  Compare that with an rsync over ssh to
the remote backup system:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          27.76    0.00   15.97    0.00    0.00   56.27

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda              10.00         4.00         0.00          8          0
sdb              10.00         4.00         0.00          8          0
sdc              10.00         4.00         0.00          8          0
sdd              10.00         4.00         0.00          8          0
sde              10.00         4.00         0.00          8          0
sdf              10.00         4.00         0.00          8          0
sdg              10.00         4.00         0.00          8          0
sdh              10.00         4.00         0.00          8          0
sdi              10.00         4.00         0.00          8          0
sdj              10.00         4.00         0.00          8          0
hda               1.50         0.00         0.04          0          0
hda1              0.00         0.00         0.00          0          0
hda2              1.50         0.00         0.04          0          0
hda3              0.00         0.00         0.00          0          0
hda4              0.00         0.00         0.00          0          0
hda5              0.00         0.00         0.00          0          0
md0             504.00        42.00         0.00         84          0

	That's 350% greater bandwidth being gulped down, and that with a
write going on at the far end.  If I do a cmp between a local file and the
same file on the backup server over NFS, I get:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4.67    0.00   21.38   27.03    0.00   46.93

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda              17.00         6.13         0.13         12          0
sdb              17.50         6.13         0.13         12          0
sdc              17.00         6.13         0.13         12          0
sdd              17.00         6.00         0.25         12          0
sde              16.50         5.75         0.25         11          0
sdf              16.00         5.75         0.25         11          0
sdg              17.50         6.10         0.16         12          0
sdh              17.00         6.13         0.13         12          0
sdi              17.00         6.13         0.13         12          0
sdj              17.00         6.13         0.13         12          0
hda               2.00         0.00         0.05          0          0
hda1              0.00         0.00         0.00          0          0
hda2              1.50         0.00         0.05          0          0
hda3              0.00         0.00         0.00          0          0
hda4              0.50         0.00         0.00          0          0
hda5              0.00         0.00         0.00          0          0
md0             720.00        60.00         0.00        120          0

	Drives sda - sdj are all members of md0.

