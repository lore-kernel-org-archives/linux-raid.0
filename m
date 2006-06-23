From: Christian Pedaschus <cpedaschus@gmx.de>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 18:46:18 +0200
Message-ID: <449C1ADA.9010907@gmx.de>
References: <449AEB7C.6040108@cjx.com> <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com> <200606231701.44803.a1426z@gawab.com> <20060623160602.GK5817@schatzie.adilger.int> <449C19BF.7060500@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <449C19BF.7060500@gmx.de>
Sender: linux-fsdevel-owner@vger.kernel.org
Cc: Andreas Dilger <adilger@clusterfs.com>, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids


Christian Pedaschus wrote:

>for ext3 use (on unmounted disks):
>tune2fs -O has_journal -o journal_data /dev/{disk}
>tune2fs -O dir_index /dev/{disk}
>
>if data is on the drive, you need to run a fsck afterwards and it uses a
>good bit of ram, but it makes ext3 a good bit faster.
>
>and my main points for using ext3 is still: "it's a very mature fs,
>nobody will tell you such horrible storys about data-lossage with ext3
>than with any other filesystem."
>and there are undelete tools for ext3.
>
>so if you're for data-integrity (i guess you are, else you would not use
>raid, or? ;) ), use ext3 and if you need the last single kb/s get a
>faster drive or use lots of them with a good raid-combo and/or use a
>separate disk for the journal (man 8 tune2fs)
>
>my 0.5 cents,
>greets chris
>
>ps. but you know, filesystem choosage is not pure science, it's
>half-religion :D
>  
>
Ops, should be:

tune2fs -O has_journal -o journal_data /dev/{partition}
tune2fs -O dir_index /dev/{partition}

;)
