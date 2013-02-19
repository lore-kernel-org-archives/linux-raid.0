From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 6, 9 1.5T days drives, 2 "fail" one after the other
Date: Mon, 18 Feb 2013 22:12:11 -0500
Message-ID: <5122ED8B.20301@turmel.org>
References: <1360181237-11760-1-git-send-email-jmaggard10@gmail.com> <20130207115328.6b07ade9@notabene.brown> <4575dbf6-5f48-446b-b144-84912415ba7e@email.android.com> <20130219113935.4f93e24a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130219113935.4f93e24a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dragos Dobrescu <dragos@mpigani.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, Dragos,

On 02/18/2013 07:39 PM, NeilBrown wrote:
> On Thu, 07 Feb 2013 10:39:53 -0500 Dragos Dobrescu
> <dragos@mpigani.org> wrote:
> 
>> Hi, I need some help. I noticed the server was in recovery mode. It
>> had just dropped a "faulty" drive. I checked the drive and it
>> looked like it was working. When the recovery was done I added the
>> drive back, after recreating the partition.
>> 
>> As soon as I did it, mdadm informed me that it redropped it and
>> dropped another drive at the same time. I removed both driver and
>> added a brand new drive (second is on the way) which the system
>> accepted and started recovery.
>> 
>> What I don't understand is that I plugged the drives on another
>> computer with sata-USB adapter and performed a full smart checkup
>> which returned successful, minus a few bad sectors and some
>> warnings of pas over heating. What is going on? Thank you for your
>> help.
>> 
>> Dragos
>> 
> 
> No one replied?  I felt sure someone else would.

No one else saw it.  The message you quoted is not in the archives, and
I never got one directly.

> Maybe you  have a problem with your driver card, or with a cable, or 
> something.

Or normal UREs.  Dragos, please also share your smartctl reports (with -x).

> Normally if md stops a driver there will be messages in the kernel
> log about access failures.  Do you still have all the logs from when
> this  happened? Are there any messages from the kernel?
> 
> NeilBrown

Phil
