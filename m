From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Tue, 27 Sep 2016 17:16:07 +0800
Message-ID: <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/09/16 09:08, Benjammin2068 wrote:
>

> Also, I just did a "repair" and the mismatch is now back to 8... which seems like a suspicious number considering the filesystem on this new drive (because it's a WD10 series with 4096byte sectors) has a slightly larger FS than the Samsung HD103SJ (and Seagate equivalents) in the array too.

See that is a bad thing to do if you even remotely suspect you have a 
problem. All a "repair" does is check the parity on a stripe and if 
there is a mismatch it re-writes it. You are writing to an array that 
apparently has issues.

I'd be checking the filesystem and file contents very carefully for 
corruption, and running several sequential check actions to keep an eye 
on the mismatch count.


