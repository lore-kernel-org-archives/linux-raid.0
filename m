From: "Jim Buttafuoco" <jim@contactbda.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 19:53:06 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040730234706.M12321@contactbda.com>
References: <b476569a04072920533b757574@mail.gmail.com> <200407300815.18296.mrwatts@fast24.co.uk> <cedoda$qn4$1@sea.gmane.org> <200407301717.36583.mrwatts@fast24.co.uk>
Reply-To: jim@contactbda.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407301717.36583.mrwatts@fast24.co.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I second Marks comment on NOT recommending the 3ware cards to anyone.  

I have a dual XEON 3.2 Ghz system 12 G of ram with a 3ware 8506-8 in it (8 250 G drives).  The hard raid performance 
was very bad.  with the load avg going over 40.  I then switched over to JBOD and software raid.  The IO wait times 
are really high and the performance sucks.  Very hard to explain to my boss where the $20k went. The system is a 
database server (postgres).  I tried both kernel 2.4 and 2.6 with the same problem.  I am now in the process of 
testing the adaptec raid controller.  


Jim
    

---------- Original Message -----------
From: Mark Watts <mrwatts@fast24.co.uk>
To: Marc Bevand <bevand_m@epita.fr>
Cc: linux-raid@vger.kernel.org
Sent: Fri, 30 Jul 2004 17:17:36 +0100
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers

> > Mark Watts wrote:
> > > With the performance issues I'm seeing with the 8506-4LP's I have, I
> > > wouldn't recommend them to anyone currently...
> > >
> > > The thread on LKML from a few days ago about mke2fs -j and 8506-4LP says
> > > it all, but basically and reasonable amount of I/O brings a Dual Opteron
> > > system to its knees.
> > > And by reasonable I mean copying ISO images from a usb2 drive to a raid 5
> > > (4 x 250GB maxtor) or even just formatting a 600MB partition.
> >
> > I would be interested to see the output of 'vmstat 1' while your system is
> > so slow.
> >
> > IMHO you shouldn't draw such conclusion ("reasonable amount of I/O brings a
> > Dual Opteron system to its knees") from your particular case. The 3 HT
> > links of the Opteron make this CPU particularly adapted to I/O operations.
> 
> Well its the only conclusion I *can* come to at this time.
> When you move from a UP 1.8Ghz P4 with single EIDE disks to SMP Opteron with 4 
> times the ram and a hardware raid card, you tend to assume that performance 
> in all areas will go up.
> When it doesn't, and you find yourself watching screen redraws while you 
> format a 600GB partition (ext3) you do feel the need to blame something :)
> 
> I'm all ears for suggestions on what me be wrong or things I can try to 
> improve performance.
> 
> >
> > Personnaly, on a dual Opteron, I am able to read datas from 4 SATA disks at
> > about 225 MB/s, with CPU time used at about 32%, awd with a system still
> > reasonably responsive.
> 
> I'm seeing ~80MB/sec reading from the 3ware raid-5 according to hdparm and 
> bonnie++
> Write performance is around 25MB/sec according to bonnie++.
> 
> Mark.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

