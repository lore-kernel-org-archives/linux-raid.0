From: Gimpbully <gimpbully@gmail.com>
Subject: Re: array went wonky
Date: Wed, 1 May 2013 11:59:16 -0700
Message-ID: <15E1BF3C-2361-4FC7-8D19-AA319C187AF5@gmail.com>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com> <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>,<F29438B9-DA12-40B1-8382-30886C95B5BD@gmail.com> <71F985BA-11B9-45E8-A17B-03F9CB5C8F52@bingner.com> <517FD8FB.7000006@turmel.org> <59BD334D-D9B3-4856-AEF3-F033E511B0DD@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59BD334D-D9B3-4856-AEF3-F033E511B0DD@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Sam Bingner <sam@bingner.com>, "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Alright, so I've ddrescued 2 disks now:
sda - clean
sdb - SMART errors, kicked out of array
sdc - SMART errors, kicked out of array
sde - ddrescued copy of sdb
sdf - original failed disk, replaced.  is now a ddrescued copy of sdc

So I run 

eduardo ~ # mdadm --assemble --force /dev/md127 /dev/sd{f,g,e,a}1
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: /dev/sdf1 has no superblock - assembly aborted
eduardo ~ # 

Any ideas?

On Apr 30, 2013, at 7:48 AM, Gimpbully <gimpbully@gmail.com> wrote:

> I have no intentions of recreating at all.  I fully understand the implications (I've had stripe orders go bad on truly massive scales before, I don't ever wanna experience that again), I just don't know mdadm as well as other vendor storage.
> 
> I was able to ddrescue a copy of sdb with no errors.  I assembled the array and got a file system metadata dump (this is HUGE) and it's currently rebuilding before I even look at data.  Thank you all for your help, patience was absolutely key here.
> 
> 
> On Apr 30, 2013, at 7:45 AM, Phil Turmel <philip@turmel.org> wrote:
> 
>> On 04/30/2013 02:20 AM, Sam Bingner wrote:
>>> On Apr 29, 2013, at 4:33 PM, "Gimpbully" <gimpbully@gmail.com>
>>> wrote:
>>>> On Apr 13, 2013, at 7:20 AM, Sam Bingner <sam@bingner.com> wrote:
>>>> 
>>>>> After that you can try to recreate the array with the proper
>>>>> order (sdc1, sdb1, sde1, missing, sda1) and copy data off or add
>>>>> the spare in again depending on if you were able to recover all
>>>>> the data wih GNU ddrescue.
>>>> 
>>>> 
>>>> What do you mean recreate?  what's the specific command?  something
>>>> like:
>>>> mdadm --create --assume-clean --level=5 --raid-devices=5 /dev/md127
>>>> /dev/sdc1 /dev/sdb1 /sdv/sde1 missing  /dev/sda1
>>> 
>>> Don't recreate it - I said the wrong thing... You want to do an
>>> assemble on them with force if possible... Recreate is last ditch and
>>> make sure you have another copy if you do the previous command in
>>> case it doesn't work right due to offsets etc...
>>> 
>>> try:
>>> mdadm --stop /dev/md127
>>> mdadm --assemble --force /dev/md127 /dev/sd{c,b,e,a}1
>> 
>> Yes.
>> 
>>> If you DO need to recreate it, what you showed looks correct.
>> 
>> NO!
>> 
>> The OP has *not* shared sufficient information on the array members to
>> say that.  Since it has "worked for years", the odds of an offset error
>> is *very* high.  Chunk size defaults are also likely to be different.
>> 
>> *Complete* output of "mdadm -E" for the array members is needed before
>> any "--create" operation is attempted.  Plus the distro info, kernel
>> version, and mdadm version .
>> 
>> Phil
> 

