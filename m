From: Phil Turmel <philip@turmel.org>
Subject: Re: array went wonky
Date: Tue, 30 Apr 2013 10:45:15 -0400
Message-ID: <517FD8FB.7000006@turmel.org>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com> <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>,<F29438B9-DA12-40B1-8382-30886C95B5BD@gmail.com> <71F985BA-11B9-45E8-A17B-03F9CB5C8F52@bingner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <71F985BA-11B9-45E8-A17B-03F9CB5C8F52@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Bingner <sam@bingner.com>
Cc: Gimpbully <gimpbully@gmail.com>, "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/30/2013 02:20 AM, Sam Bingner wrote:
> On Apr 29, 2013, at 4:33 PM, "Gimpbully" <gimpbully@gmail.com>
> wrote:
>> On Apr 13, 2013, at 7:20 AM, Sam Bingner <sam@bingner.com> wrote:
>> 
>>> After that you can try to recreate the array with the proper
>>> order (sdc1, sdb1, sde1, missing, sda1) and copy data off or add
>>> the spare in again depending on if you were able to recover all
>>> the data wih GNU ddrescue.
>> 
>> 
>> What do you mean recreate?  what's the specific command?  something
>> like:
>> mdadm --create --assume-clean --level=5 --raid-devices=5 /dev/md127
>> /dev/sdc1 /dev/sdb1 /sdv/sde1 missing  /dev/sda1
> 
> Don't recreate it - I said the wrong thing... You want to do an
> assemble on them with force if possible... Recreate is last ditch and
> make sure you have another copy if you do the previous command in
> case it doesn't work right due to offsets etc...
> 
> try:
> mdadm --stop /dev/md127
> mdadm --assemble --force /dev/md127 /dev/sd{c,b,e,a}1

Yes.

> If you DO need to recreate it, what you showed looks correct.

NO!

The OP has *not* shared sufficient information on the array members to
say that.  Since it has "worked for years", the odds of an offset error
is *very* high.  Chunk size defaults are also likely to be different.

*Complete* output of "mdadm -E" for the array members is needed before
any "--create" operation is attempted.  Plus the distro info, kernel
version, and mdadm version .

Phil
