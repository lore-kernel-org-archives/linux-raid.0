From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Fri, 09 Sep 2011 17:54:38 -0400
Message-ID: <4E6A8B1E.7050102@tmr.com>
References: <4E57FE4D.5080503@vorgon.com> <20110827084535.5e64bf5c@notabene.brown> <4E5FC63A.1040206@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FC63A.1040206@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Timothy D. Lenz wrote:
>
>
> On 8/26/2011 3:45 PM, NeilBrown wrote:
>
> Got another problem. Removed the drive and tried to start it back up 
> and now get Grub Error 2. I'm not sure if when I did the mirrors if 
> something when wrong with installing grub on the second drive< or if 
> is has to do with [U_] which points to sda in that report instead of 
> [_U].
>
> I know I pulled the correct drive. I had it labled sdb, it's the 
> second drive in the bios bootup drive check and it's the second 
> connector on the board. And when I put just it in instead of the 
> other, I got the noise again.  I think last time a drive failed it was 
> one of these two drives because I remember recopying grub.
>
> I do have another computer setup the same way, that I could put this 
> remaining drive on to get grub fixed, but it's a bit of a pain to get 
> the other computer hooked back up and I will have to dig through my 
> notes about getting grub setup without messing up the array and stuff. 
> I do know that both computers have been updated to grub 2
>
I like to check the table of device names vs. make/model/serno before 
going to far. I get the out of blkdevtrk to be sure.


-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



