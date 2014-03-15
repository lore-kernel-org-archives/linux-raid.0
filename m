From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid stalls during --replace and other disk activity...
Date: Sat, 15 Mar 2014 15:19:05 -0400
Message-ID: <5324A7A9.1040700@turmel.org>
References: <CAK_KU4bEFkydyqJfrUWNoq9R7AxVwPU29Kyzp+5mn=tmf7GgHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4bEFkydyqJfrUWNoq9R7AxVwPU29Kyzp+5mn=tmf7GgHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/15/2014 12:28 AM, Scott D'Vileskis wrote:

> However, when I started a format of an unrelated partition on
> /dev/sda, the RAID 'recovery' disk-replacement completely stopped. I
> suspect the RAID rebuild mechanism is pausing because of the activity
> on /dev/sda.
> 
> I monkeyed with
> echo 90000 > speed_limit_min
> and now I get 10 second bursts of 20-100MB/sec every 30 seconds or so,
> so at least the jobs will finish in parallel..
> 
> I feel the RAID --replace option should only concern itself with the
> two disks involved not get caught up because of activity on another
> disk. Is this a bug?

This is deliberate, and in my opinion, desirable.  Same thing happens
when doing a check or any kind of rebuild on multiple arrays that use
partitions on shared underlying devices.  If you don't limit the raid
background activity, the extra seek load on the devices can severely cut
performance, especially on spinning rust.

Phil

