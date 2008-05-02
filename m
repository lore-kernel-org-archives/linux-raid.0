From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Sleeping hard drives in an array?
Date: Fri, 02 May 2008 17:11:10 -0400
Message-ID: <481B836E.6040208@tmr.com>
References: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Cormier wrote:
> Is it possible to sleep hard drives in an array?
>
> I have a HTPC at home that's on 24x7. It does all my torrenting as
> well, and is mainly a media server.
>
> Can I sleep the drives in my RAID5 array while it's not being used?
> It's an XFS partition.
>
> I have each drive set as
>
> hdparm -S240 /dev/sdX
>
> But I'm fairly sure they are not spinning down :( Is there some
> activity mdadm is doing in the background?
>
> These things are probably idle 22 hours of the day.
>   

I have several very similar systems, and I note that on one the disk 
light blinks every five sec or so, while the others don't do that. The 
one that blinks is the only one running LVM, all the others were 
partitioned by hand. Does that apply to your system, LVM in use?

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


