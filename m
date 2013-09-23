From: Phil Turmel <philip@turmel.org>
Subject: Re: Array member "role numbers" in /proc/mdstat
Date: Mon, 23 Sep 2013 13:50:00 -0400
Message-ID: <52407F48.7020805@turmel.org>
References: <52406A79.4030808@gmail.com> <52406E0C.4080207@mpstor.com> <52406EBB.1010507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52406EBB.1010507@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: Benjamin ESTRABAUD <be@mpstor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/23/2013 12:39 PM, Ian Pilcher wrote:
> On 09/23/2013 11:36 AM, Benjamin ESTRABAUD wrote:
>> Are you referring to the particular mention"Any device with "n" or
>> higher are spare disks. 0,1,..,n-1 are for the working array." in the
>> Mdstat wiki page?
> 
> I was really thinking of the sentence before that, which states:
> 
>   The raid role numbers [#] following each device indicate its role, or
>   function, within the raid set.

The wiki is wrong.  The number in brackets is the device's index into
the *table* of roles in the superblock.  In a new array, table entries
are allocated sequentially, which makes it *look* like the role numbers.

Phil
