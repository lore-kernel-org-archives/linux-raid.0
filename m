From: Phil Turmel <philip@turmel.org>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 11:52:20 -0500
Message-ID: <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Gandalf,

On 11/29/2017 11:44 AM, Reindl Harald wrote:

> Am 29.11.2017 um 17:22 schrieb Gandalf Corvotempesta:
>> Hi to all
>> I have to setup some new servers, which is the best practise, currently?
>> Should I use raw devices or partitions ? (one huge partition for
>> mdadm, and then
>> LVM on top of it)
>>
>> Any advantage/drawbacks for both configurations?
> 
> i would make partitions for 2 reasons:
> 
> * leave some space free in case a replacement disk has
>   a slighty different usebale size - some SSD's do
>   this instead overprovisioning for wear leveling
> 
> * whenever you decide you replace it against SSD's
>   free space will enhance the overall lifetime

These are good reasons.  I have also seen reports of NAS devices/distros
unconditionally partitioning devices that don't have one.  Although I
have in the past used raw devices with mdadm, I don't plan to do so with
any future systems.

Phil
