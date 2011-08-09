From: NeilBrown <neilb@suse.de>
Subject: Re: Need help recovering RAID5 array
Date: Tue, 9 Aug 2011 12:55:49 +1000
Message-ID: <20110809125549.00c56f57@notabene.brown>
References: <4E3C0BCA.9000407@uml.edu>
	<20110806112910.332d450a@notabene.brown>
	<D32562736F94C445958A7CC900A95568265503@PORSCHE.fs.uml.edu>
	<20110809091214.4a830696@notabene.brown>
	<4E409B76.5030000@uml.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E409B76.5030000@uml.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Muskiewicz <stephen_muskiewicz@uml.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 8 Aug 2011 22:29:10 -0400 Stephen Muskiewicz
<stephen_muskiewicz@uml.edu> wrote:
> 
> Well it looks like the first try didn't work, but adding the --force 
> seems to have done the trick!  Here's the results:
> 

snip

> 
> So it looks like I'm in business again!  Many thanks!

Great!

> 
> This does lead to a question: Do you recommend (and is it safe on CentOS 
> 5.5?) for me to use the updated (3.2.2 with your patch) version of mdadm 
> going forward in place of the CentOS version (2.6.9)?

I wouldn't kept that patch.  It was a little hack to get your array working
again.  I wouldn't recommend using it without expert advice...

Other than that ... 3.2.2 certainly fixes bug and adds features over 2.6.9,
but maybe it adds some bugs too...  I would say that it is safe, but probably
not really necessary.
i.e. up to you :-)

> 
> > I wonder how the event count got that high.  There aren't enough seconds
> > since the birth of the universe of it to have happened naturally...
> >
> Any chance it might be related to these kernel messages? I just noticed 
> (guess I should be paying more attention to my logs) that there are tons 
> of these messages repeated in my /var/log/messages file.  However as far 
> as the RAID arrays themselves, we haven't seen any problems while they 
> are running so I'm not sure what's causing these or whether they are 
> insignificant.  Again, speculation on my part but given the huge event 
> count from mdadm and the number of these messages it might seem that 
> they are somehow related....
> 
> Jul 31 04:02:13 libthumper1 kernel: program diskmond is using a 
> deprecated SCSI
> ioctl, please convert it to SG_IO
> Jul 31 04:02:26 libthumper1 last message repeated 47 times
> Jul 31 04:12:11 libthumper1 kernel: md: bug in file drivers/md/md.c, 
> line 1659

I need to know the exact kernel version to find out what this line is.... I
could guess but I would probably be wrong.

> Jul 31 04:12:11 libthumper1 kernel:
> Jul 31 04:12:11 libthumper1 kernel: md: **********************************
> Jul 31 04:12:11 libthumper1 kernel: md: * <COMPLETE RAID STATE PRINTOUT> *
> Jul 31 04:12:11 libthumper1 kernel: md: **********************************
> Jul 31 04:12:11 libthumper1 kernel: md53: 
> <sdk1><sdai1><sds1><sdam1><sdo1><sdau1><sdaq1><sdw1><sdaa1><sdae1>
> Jul 31 04:12:11 libthumper1 kernel: md: rdev sdk1, SZ:488383744 F:0 S:1 
> DN:10
> Jul 31 04:12:11 libthumper1 kernel: md: rdev superblock:
> Jul 31 04:12:11 libthumper1 kernel: md:  SB: (V:1.0.0) 
> ID:<be475f67.00000000.00000000.00000000> CT:81f4e22f
> Jul 31 04:12:11 libthumper1 kernel: md:     L-2009873429 S1801675106 
> ND:1834971253 RD:1869771369 md114 LO:65536 CS:196610
> Jul 31 04:12:11 libthumper1 kernel: md:     UT:00000000 ST:0 
> AD:976767728 WD:0 FD:976767984 SD:0 CSUM:00000000 E:00000000
> Jul 31 04:12:11 libthumper1 kernel:      D  0:  DISK<N:-1,(-1,-1),R:-1,S:-1>
> Jul 31 04:12:11 libthumper1 kernel:      D  1:  DISK<N:-1,(-1,-1),R:-1,S:-1>
> Jul 31 04:12:11 libthumper1 kernel:      D  2:  DISK<N:-1,(-1,-1),R:-1,S:-1>
> Jul 31 04:12:11 libthumper1 kernel:      D  3:  DISK<N:-1,(-1,-1),R:-1,S:-1>
> Jul 31 04:12:11 libthumper1 kernel: md:     THIS:  DISK<N:0,(0,0),R:0,S:0>
> Jul 31 04:12:11 libthumper1 kernel: md: rdev superblock:
> Jul 31 04:12:11 libthumper1 kernel: md:  SB: (V:1.0.0) 
> ID:<be475f67.00000000.00000000.00000000> CT:81f4e22f
> Jul 31 04:12:11 libthumper1 kernel: md:     L-2009873429 S1801675106 
> ND:1834971253 RD:1869771369 md114 LO:65536 CS:196610
> Jul 31 04:12:11 libthumper1 kernel: md:     UT:00000000 ST:0 
> AD:976767728 WD:0 FD:976767984 SD:0 CSUM:00000000 E:00000000
> 
> <snip...and on and on>

Did it really start repeating at this point?  I would have expected a bit
more first.

So if you get me kernel version and confirm that this really is all in the
logs except for identical repeats, I'll see if I can figure out what might
have caused it - and then if it could be related to your original problem.

> 
> Of course given how old the CentOS mdadm is, maybe by updating it I'll 
> be fixing this problem as well?

In general running newer code should be safer and easier to support.  Don't
know if it would fix this problem yet though.


NeilBrown




> If not, I'd be willing to help delve deeper if it's something worth 
> investigating.
> 
> Again, Thanks a ton for all your help and quick replies!
> 
> Cheers!
> -steve
> 
> > Thanks,
> > NeilBrown
> >
> > diff --git a/super1.c b/super1.c
> > index 35e92a3..4a3341a 100644
> > --- a/super1.c
> > +++ b/super1.c
> > @@ -803,6 +803,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
> >   		       __le64_to_cpu(sb->data_size));
> >   	} else if (strcmp(update, "_reshape_progress")==0)
> >   		sb->reshape_position = __cpu_to_le64(info->reshape_progress);
> > +	else if (strcmp(update, "summaries") == 0)
> > +		sb->events = __cpu_to_le64(4);
> >   	else
> >   		rv = -1;
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

