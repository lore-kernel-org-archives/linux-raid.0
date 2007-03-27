From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: split raid1 into to arrays
Date: Tue, 27 Mar 2007 11:57:12 -0400
Message-ID: <46093ED8.8020201@tmr.com>
References: <5d0f60990703261954l2bb8c225ocbc3cf66e868723a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d0f60990703261954l2bb8c225ocbc3cf66e868723a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dirk Jagdmann <jagdmann@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dirk Jagdmann wrote:
> Hello experts,
>
> I have a raid1 array with two drives working. It /dev/md0 built from
> /dev/hda and /dev/hdb. Now I'd like to split it into two array with
> one drive each (and then later add spares to my two arrays again). I
> know that I can remove one drive from the array with: mdadm /dev/md0
> -f /dev/hdb -r /dev/hdb , however I'm not sure what the superblock of
> /dev/hdb now contains and how I could use the contents of /dev/hdb as
> the starting point for my new /dev/md1 array? I did not find anything
> in the manpage of mdadm which would provide me an automatic split.
>
> So what are your advises?
>
The fast way (not redundant):
  You can mark hdb as failed, then remove it. Then you can create a new 
array using hdb and a missing device.

The safe way:
  get your additional drives, call then hdc and hdd just for discussion.
 add hdc to the existing array and let it rebuild, then mark hdb as 
failed and remove. Create a new array from hdb and hdd.

I'm sure someone will tell me if I left out a step.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

