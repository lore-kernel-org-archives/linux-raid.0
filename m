From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: RAID5 Problem - $1000 reward for help
Date: Sun, 17 Sep 2006 10:37:03 +0300
Message-ID: <5b170a7d0609170037j52db8ec6u4f1603101e1718a@mail.gmail.com>
References: <20060915090856.GD27597@boom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060915090856.GD27597@boom.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Reza Naima <reza@reza.net>
Cc: linux-raid@vger.kernel.org, Taner Halicioglu <taner@taner.net>
List-Id: linux-raid.ids

On 9/15/06, Reza Naima <reza@reza.net> wrote:
> I've picked up two 500G disks, and am in the process of dd'ing the
> contents of the raid partitions over.  The 2nd failed disk came up just
> fine, and has been coping the data over without fault.  I expect it to
> finish, but thought I would send this email now.  I will include some
> data that I captured before the system failed.

Note that if there are bad blocks, dd might not be reliable,
"ddrescue" will do a better job of filling the gaps with zeroes
(silent data corruption may result).

The theory with your problem is to recreate the raid in degraded mode
(the replaced drive as missing), something like

mdadm --create /dev/md0 --chunk=256 --layout=left-symmetric
--raid-devices=4 /dev/hda3 missing /dev/hdf1 /dev/hdg1

after which see if the filesystem mounts and is ok, if so, add the
remaining drive back to the array.

It's recommended to use a script to scrub the raid device regularly,
to detect sleeping bad blocks early.
