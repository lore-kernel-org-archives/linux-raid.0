From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Fwd: Majordomo results: Re: Majordomo results: .
Date: Wed, 24 Feb 2010 01:50:28 -0800 (PST)
Message-ID: <394052.48164.qm@web51305.mail.re2.yahoo.com>
References: <e4ae6451002240145i704454cdt94435913054c6122@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e4ae6451002240145i704454cdt94435913054c6122@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com, Felipe Alvarez <felipe.alvarez@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Wed, 24/2/10, Felipe Alvarez <felipe.alvarez@gmail.com> wrote:

> From: Felipe Alvarez <felipe.alvarez@gmail.com>
> Subject: Re: Fwd: Majordomo results: Re: Majordomo results: .
> To: Jon@ehardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Wednesday, 24 February, 2010, 9:45
> > The beauty of that being that
> when all the drives
> > have been retired/failed and the smallest partition
> > size is now 500GB or whatever you can
> > --grow=max and get that unused space.
> >
> Thanks. That's a good idea, because I would eventually like
> to make
> the array larger than it is as the drives get replaced, one
> at a time.
> Would the command be:
> $ mdadm --grow /dev/md0 --size=max DEVICE1 DEVICE2 DEVICE3
> DEVICE4
> 
> Felipe
> --

Think it is simply mdadm --grow /dev/md0 --size=max 

But speaking from experience you'll likely run out of space before the bitter pill of retiring the drives/being unlucky enough for them to fail happens. You'll be adding new drives before you know it! And then... you'll probably want to consider RAID6 once you go over ~1TB per drive.



      
