From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 dead on the water after Controller failure
Date: Sat, 15 Feb 2014 14:01:39 -0500
Message-ID: <52FFB993.10804@turmel.org>
References: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com> <52FE7E2D.8020308@turmel.org> <5269CCC7-A0A7-479E-9738-88C74CB19435@gmail.com> <52FF83F1.3030904@turmel.org> <8D85C29C-685E-457A-BA2A-5F9069122D88@gmail.com> <52FFB932.3060808@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52FFB932.3060808@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Florian Lampel <florian.lampel@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/15/2014 02:00 PM, Phil Turmel wrote:
> Hi Florian,
> 
> mdadm --stop /dev/md0
> mdadm -AfRv/dev/md0 /dev/sd[abcefghjklm]1

Actually, you can probably just issue "mdadm --run /dev/md0" instead of
stopping and re-assembling.

Phil

