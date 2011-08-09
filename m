From: "Muskiewicz, Stephen C" <Stephen_Muskiewicz@uml.edu>
Subject: RE: Need help recovering RAID5 array
Date: Tue, 9 Aug 2011 14:47:33 +0000
Message-ID: <D32562736F94C445958A7CC900A95568265E97@PORSCHE.fs.uml.edu>
References: <4E3C0BCA.9000407@uml.edu>
	<20110806112910.332d450a@notabene.brown>
	<D32562736F94C445958A7CC900A95568265503@PORSCHE.fs.uml.edu>
	<20110809091214.4a830696@notabene.brown>	<4E409B76.5030000@uml.edu>
 <20110809125549.00c56f57@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110809125549.00c56f57@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, August 08, 2011 10:56 PM
> To: Muskiewicz, Stephen C
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Need help recovering RAID5 array
> 
> >
> > This does lead to a question: Do you recommend (and is it safe on
> CentOS
> > 5.5?) for me to use the updated (3.2.2 with your patch) version of
> mdadm
> > going forward in place of the CentOS version (2.6.9)?
> 
> I wouldn't kept that patch.  It was a little hack to get your array
> working
> again.  I wouldn't recommend using it without expert advice...
> 
> Other than that ... 3.2.2 certainly fixes bug and adds features over
> 2.6.9,
> but maybe it adds some bugs too...  I would say that it is safe, but
> probably
> not really necessary.
> i.e. up to you :-)
> 

OK, I'll probably stick with 2.6.9 for now and focus on getting our other thumper server updated to CentOS 6 then.  Oh yeah and getting the UPS control software so it actually shuts down the box cleanly so this hopefully doesn't happen again! ;-)

> >
> > > I wonder how the event count got that high.  There aren't enough
> seconds
> > > since the birth of the universe of it to have happened naturally...
> > >
> > Any chance it might be related to these kernel messages? I just
> noticed
> > (guess I should be paying more attention to my logs) that there are
> tons
> > of these messages repeated in my /var/log/messages file.  However as
> far
> > as the RAID arrays themselves, we haven't seen any problems while
> they
> > are running so I'm not sure what's causing these or whether they are
> > insignificant.  Again, speculation on my part but given the huge
> event
> > count from mdadm and the number of these messages it might seem that
> > they are somehow related....
> >
> > Jul 31 04:02:13 libthumper1 kernel: program diskmond is using a
> > deprecated SCSI
> > ioctl, please convert it to SG_IO
> > Jul 31 04:02:26 libthumper1 last message repeated 47 times
> > Jul 31 04:12:11 libthumper1 kernel: md: bug in file drivers/md/md.c,
> > line 1659
> 
> I need to know the exact kernel version to find out what this line
> is.... I
> could guess but I would probably be wrong.
> 
> > Jul 31 04:12:11 libthumper1 kernel:
> > Jul 31 04:12:11 libthumper1 kernel: md:
> **********************************
> > Jul 31 04:12:11 libthumper1 kernel: md: * <COMPLETE RAID STATE
> PRINTOUT> *
> > Jul 31 04:12:11 libthumper1 kernel: md:
> **********************************
> > Jul 31 04:12:11 libthumper1 kernel: md53:
> > <sdk1><sdai1><sds1><sdam1><sdo1><sdau1><sdaq1><sdw1><sdaa1><sdae1>
> > Jul 31 04:12:11 libthumper1 kernel: md: rdev sdk1, SZ:488383744 F:0
> S:1
> > DN:10
> > Jul 31 04:12:11 libthumper1 kernel: md: rdev superblock:
> > Jul 31 04:12:11 libthumper1 kernel: md:  SB: (V:1.0.0)
> > ID:<be475f67.00000000.00000000.00000000> CT:81f4e22f
> > Jul 31 04:12:11 libthumper1 kernel: md:     L-2009873429 S1801675106
> > ND:1834971253 RD:1869771369 md114 LO:65536 CS:196610
> > Jul 31 04:12:11 libthumper1 kernel: md:     UT:00000000 ST:0
> > AD:976767728 WD:0 FD:976767984 SD:0 CSUM:00000000 E:00000000
> > Jul 31 04:12:11 libthumper1 kernel:      D  0:  DISK<N:-1,(-1,-1),R:-
> 1,S:-1>
> > Jul 31 04:12:11 libthumper1 kernel:      D  1:  DISK<N:-1,(-1,-1),R:-
> 1,S:-1>
> > Jul 31 04:12:11 libthumper1 kernel:      D  2:  DISK<N:-1,(-1,-1),R:-
> 1,S:-1>
> > Jul 31 04:12:11 libthumper1 kernel:      D  3:  DISK<N:-1,(-1,-1),R:-
> 1,S:-1>
> > Jul 31 04:12:11 libthumper1 kernel: md:     THIS:
> DISK<N:0,(0,0),R:0,S:0>
> > Jul 31 04:12:11 libthumper1 kernel: md: rdev superblock:
> > Jul 31 04:12:11 libthumper1 kernel: md:  SB: (V:1.0.0)
> > ID:<be475f67.00000000.00000000.00000000> CT:81f4e22f
> > Jul 31 04:12:11 libthumper1 kernel: md:     L-2009873429 S1801675106
> > ND:1834971253 RD:1869771369 md114 LO:65536 CS:196610
> > Jul 31 04:12:11 libthumper1 kernel: md:     UT:00000000 ST:0
> > AD:976767728 WD:0 FD:976767984 SD:0 CSUM:00000000 E:00000000
> >
> > <snip...and on and on>
> 
> Did it really start repeating at this point?  I would have expected a
> bit
> more first.
> 
> So if you get me kernel version and confirm that this really is all in
> the
> logs except for identical repeats, I'll see if I can figure out what
> might
> have caused it - and then if it could be related to your original
> problem.
> 

Yes you're right, there is quite a bit more of the info in the logs in between the "bug in file ... line 1659" message.  It looks to be a state dump for each device in the array.  I'll save the bandwidth and not paste all of that in here unless you need it.  But I have confirmed that all of the bug lines are for the same line number (approx 60000 occurrences in the old backup of the messages file alone):

libthumper1 kernel: md: bug in file drivers/md/md.c, line 1659

Here's the kernel version and RPM info:

[root@libthumper1 ~]# uname -a
Linux libthumper1.uml.edu 2.6.18-194.32.1.el5 #1 SMP Wed Jan 5 17:52:25 EST 2011 x86_64 x86_64 x86_64 GNU/Linux

[root@libthumper1 ~]# rpm -qi kernel-2.6.18-194.32.1.el5
Name        : kernel                       Relocations: (not relocatable)
Version     : 2.6.18                            Vendor: CentOS
Release     : 194.32.1.el5                  Build Date: Wed 05 Jan 2011 08:44:05 PM EST
Install Date: Tue 25 Jan 2011 03:13:55 PM EST      Build Host: builder10.centos.org
Group       : System Environment/Kernel     Source RPM: kernel-2.6.18-194.32.1.el5.src.rpm
Size        : 96513754                         License: GPLv2
Signature   : DSA/SHA1, Thu 06 Jan 2011 07:16:03 AM EST, Key ID a8a447dce8562897
URL         : http://www.kernel.org/
<snip>

Let me know if I can provide any other useful info.

Again, many thanks for all your help!

Cheers,
-steve



