From: Phil Turmel <philip@turmel.org>
Subject: Re: Kernel preventing (extra) spare disk in array from entering
 standby
Date: Wed, 25 Oct 2017 09:56:33 -0400
Message-ID: <5aac3242-723f-fce9-a438-1ca95f5d4d50@turmel.org>
References: <CAJO99TkXsobN3EszoPM37y=Eth-URQeLTSd8fBDpATHg1x-tmQ@mail.gmail.com>
 <f656c779-f376-82a2-cf2f-769767b478d6@turmel.org>
 <CAJO99Tn=1TRahO1gH4KW-8=g4rdf4PaCbPMbR3a6Ui1c_i3QuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJO99Tn=1TRahO1gH4KW-8=g4rdf4PaCbPMbR3a6Ui1c_i3QuQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Bj=c3=b8rnar_Ness?= <bjornar.ness@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/25/2017 05:28 AM, Bjørnar Ness wrote:
> On Oct 24, 2017 20:31, "Phil Turmel" <philip@turmel.org> wrote:
>>
>> That sounds like writes to the write-intent bitmap, which happens to all
>> devices in an array while degraded.
>>
>> Why do you have 12 spares attached to the array?  That seems a bit
>> excessive.
> 
> This is a 60 disk array, and the only reason for having 12 disks as spares
> (could be any number, really) is the frequency of visiting datacenter.

Ok.

> There are multiple arrays, and these spares are moved as they are needed,
> but as far as I can tell, it is not easy if at all possible to
> distribute slaves evenly
> among arrays when using udev rules and --incremental to add them.

If you are using spare groups to allow the spares to move where needed,
then you don't actually need to have all of these spares attached to
your arrays.  Consider using just one or two.  Then use a cron job or
custom mdadm --monitor script to add one of the unattached spares to any
array when an event consumes one of your active spares.

Phil
