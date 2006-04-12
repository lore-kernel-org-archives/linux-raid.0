From: Luca Berra <bluca@comedia.it>
Subject: Re: [RAID] forcing a read on a known bad block
Date: Wed, 12 Apr 2006 07:18:03 +0200
Message-ID: <20060412051803.GA19309@percy.comedia.it>
References: <Pine.LNX.4.64.0604092000020.29514@twinlark.arctic.org> <Pine.LNX.4.64.0604111232010.6603@taurus.cesta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0604111232010.6603@taurus.cesta.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 11, 2006 at 12:37:53PM -1000, Julian Cowley wrote:
>On Tue, 11 Apr 2006, dean gaudet wrote:
>>anyhow this made me wonder if there's some other existing trick to force
>>such reads/reconstructions to occur... or perhaps this might be a useful
>>future feature.
>
>For testing RAID, what would be really nice is if there were a virtual
>disk device where one could simulate bad sectors (read or write),
>non-responsive disks, etc.  It would be virtual in the same sort way
>that /dev/full simulates a full disk.
>
either use the MD "faulty" personality, or the device-mapper "error"
target.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
