From: Phil Turmel <philip@turmel.org>
Subject: Re: Installing Linux directly onto RAID6 Array...........
Date: Tue, 12 May 2015 08:20:42 -0400
Message-ID: <5551F01A.4050705@turmel.org>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <5551D3F2.8020007@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5551D3F2.8020007@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Another Sillyname <anothersname@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/12/2015 06:20 AM, Rudy Zijlstra wrote:
> Hi
> 
> Another Sillyname schreef op 12-05-15 om 12:08:
>> I've tried to do some research on this but the information out there
>> seems a bit contradictory (mainly because some is so old).
>>
>> I want to install Fedora directly onto a RAID array (no separate boot
>> disk).
> 
> 
> Doing something like that... and using network boot to solve those issues
> 
> Last i tried grub2 could not handle a raid6 directly (could be changed now)

You could also boot from a USB device, possibly one that memory caches
its root filesystem (like System Rescue CD).

Phil

