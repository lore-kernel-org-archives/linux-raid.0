From: Phil Turmel <philip@turmel.org>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 13:11:03 -0500
Message-ID: <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Bosner <martin@bosner.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Martin,

On 02/20/2017 12:48 PM, Martin Bosner wrote:
> Hi Phil,
> 
>> { Note: convention on kernel.org is reply-to-all, bottom post or 
>> interleave, and trim unneeded material. }
> Sorry, hope this one is better.
> 
> 
>> for x in /dev/sd[a-z] /dev/sda[a-j] ; do mdadm -E ${x}1 ; done
> 
> See below for full output.

Not good.

>> Eewwww!  You have desktop drives.  Which means your array has
>> blown up due to timeout mismatch.  You have some reading to do.[1]

Of the 36 original disks, you have 34.  You have one incomplete
rebuild, meaning it is still technically a spare. One of the still
active 34 is also showing pending relocations, meaning that disk will
not be able to supply all sectors to complete any recovery.
{ /dev/sdah, serial # S1F0FPYR }

If you have any access to the two "dead" drives, there might be
a slight chance. Since they were likely kicked out due to timeout
mismatch, not a complete failure, this could be possible.

Otherwise, you are utterly screwed.  Sorry.

> I will be using so called “NAS” or “enterprise disks in the next 
> cluster …  especially these seagate disks were a bad decision.

Yes.

Phil

