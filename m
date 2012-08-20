From: David Brown <david.brown@hesbynett.no>
Subject: Re: md raid behavior, bad sector uncorrectable read error
Date: Mon, 20 Aug 2012 08:36:01 +0200
Message-ID: <5031DAD1.5050502@hesbynett.no>
References: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com> <CAGkViCFBqJJWeaA1Wrpc_BBw=wd1wV3nVrArEB51LJpJsrmsug@mail.gmail.com> <FEEB11B4-5CCB-49F4-8010-80CE03A49FA4@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FEEB11B4-5CCB-49F4-8010-80CE03A49FA4@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/08/2012 20:12, Chris Murphy wrote:

>
> On Aug 19, 2012, at 3:47 AM, Mikael Abrahamsson wrote:
>> If I remember correctly from what has been described here before, a
>> read error will cause a re-write with information created from
>> parity
>
> That's the thing I'd like to get a definitive answer one. If only it
> were easy to simulate bad sectors in VM's I could just test it!
>

I wonder why no one has thought of this idea before...  Wait a minute, 
they have!  When you read the "man 4 md" or "man mdadm" pages, read 
about the "faulty" module.  You don't have to use a virtual machine for 
this, it has been used for testing md raid from long before virtual 
machines were practical in the PC world.

(Sorry for the sarcasm - it was just too tempting in light of Neil's 
recommendation to read the "man 4 md" page!)

Have fun playing with these things - it's good practice so you know what 
to expect if a real failure occurs.

>> If it throws a write error, the drive is kicked from the array
>> (because a drive with write errors is clearly defective).
>
> That makes complete sense.
>
