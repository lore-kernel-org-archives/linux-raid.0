From: Phil Turmel <philip@turmel.org>
Subject: Re: Damage when growing RAID 5 array
Date: Mon, 25 Feb 2013 22:24:35 -0500
Message-ID: <512C2AF3.90501@turmel.org>
References: <C4E6825B-3AF2-40E7-BD1B-65F988171FF2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C4E6825B-3AF2-40E7-BD1B-65F988171FF2@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kevin McAreavey <kevin.mcareavey@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/25/2013 04:17 PM, Kevin McAreavey wrote:

> $ sudo mdadm --assemble /dev/md1
> mdadm: Failed to restore critical section for reshape, sorry.
>       Possibly you needed to specify the --backup-file

Did you follow this advice?  I doesn't look like it from the rest of
your report.  (Reread that without the word "Possibly".)

Phil
