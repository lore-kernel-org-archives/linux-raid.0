From: Jessie Evangelista <jessie.evangelista@gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Tue, 20 Mar 2012 20:34:49 +0800
Message-ID: <CAA8mOyDPhGfPUcfSi4CaTo_d0bZZGZg=2Y1eWqghmvm6LRhN6w@mail.gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com>
	<20120317223454.GQ5091@dastard>
	<20325.17387.216150.45013@tree.ty.sabi.co.UK>
	<20325.50714.237894.328039@tree.ty.sabi.co.UK>
	<20120318140051.GA2594@infradead.org>
	<20326.13500.799169.828158@tree.ty.sabi.co.UK>
	<4F66F74D.3030909@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F66F74D.3030909@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

Thank you everyone for you insights and comments.

I made a post of how I proceeded here:
http://blog.henyo.com/2012/03/cheap-and-safe-file-storage-on-linux.html

In summary, I did some benchmarks with bonnie++ using different raid
levels(5,10n2,10f2,10o2) using different chunks(64,128,256,512,1024)
using different file systems(xfs,ext4) and different settings for each
file system.

I decided to go with ext4 because I wanted to make use of the
data=journal option which IMHO is safer albeit slower.
