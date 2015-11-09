From: Phil Turmel <philip@turmel.org>
Subject: Re: Offline array, events count mismatch
Date: Sun, 8 Nov 2015 22:35:13 -0500
Message-ID: <56401471.2040605@turmel.org>
References: <1903758.3ih4aa4jR2@carbon.lepommierdujardin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1903758.3ih4aa4jR2@carbon.lepommierdujardin.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Paumier <guillaume.paumier@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Guillaume,

On 11/08/2015 09:49 PM, Guillaume Paumier wrote:

[trim /]

> Looking at those event counts, my understanding is this:
> * Two of the disks (sde, sdf) were dropped from the array for some reason.
> * I didn't notice this immediately (an issue I'm addressing separately).
> * A third disk (sdj) encountered a small issue today.
> * The array went offline because it didn't have enough disks to function 
> cleanly any more.
> 
> If I understand the documentation [1] correctly, since the event count for sdj 
> is very close to the event count of sd[b,c,d,g,h,i], I should be able to re-
> assemble the array with these 7 disks using --force, leaving sde and sdf 
> aside. Once the array is assembled, I should be able to re-add sde and sdf, 
> and they will be re-sync'd.

Yes, that is the correct response.

Your situation is common.  Please see the thread this weekend started by
Franscisco Parada.

https://marc.info/?t=144691643300001&r=1&w=2&n=12

You should provide "smartctl -i -A -l scterc /dev/sdX" reports for your
drives.  If you can find an old syslog for when your two worst drives
fell out, it might help.

Phil
