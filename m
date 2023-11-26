Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABDCE4
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 14:52:54 -0800 (PST)
Received: from nvm (unknown [IPv6:fd39::101])
	by shin.romanrm.net (Postfix) with SMTP id 29C793F083;
	Sun, 26 Nov 2023 22:52:43 +0000 (UTC)
Date: Mon, 27 Nov 2023 03:52:37 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux RAID Mailing List
 <linux-raid@vger.kernel.org>
Subject: Re: SMR or SSD disks?
Message-ID: <20231127035237.3e7d78da@nvm>
In-Reply-To: <CAJH6TXiKLitvausMWgwZ_kNQbvp7sDA4AfaLvO2M54E7qLq8cg@mail.gmail.com>
References: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
	<ZWMf+lg/CgRlxKtb@mail.bitfolk.com>
	<20938de4-65f2-4bab-90c0-018fe485c0e7@suse.de>
	<d1ab59c2-e172-400d-8d6c-68f4bfce3a65@youngman.org.uk>
	<CAJH6TXiKLitvausMWgwZ_kNQbvp7sDA4AfaLvO2M54E7qLq8cg@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 26 Nov 2023 23:22:51 +0100
Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com> wrote:

> Il giorno dom 26 nov 2023 alle ore 13:22 Wols Lists
> <antlists@youngman.org.uk> ha scritto:
> > If you look at what SMR is, it's only relevant to spinning rust. It
> > relies on the fact that a read head can be much smaller than a write
> > head, so provided you shingle your writes (hence the name), you can
> > over-write half the previous track (so saving space) without rendering
> > the data unreadable.
> 
> Thank you all.
> That's what i've thought but better stay safe than sorry so i've asked.
> 
> In other words WD Red SSD are safe for a RAID, there is no need to change them
> (as mostly new) in both array (the grow was finished 1 hour ago: 2 WD
> Gold SATA 3.5 plus 1 WD RED SSD)
> 
> Slowly, i'll replace all spinning disks with WD Red SSD
> I'm not a fan of WD, but 2TB disks able to replace a 2TB HDD are very
> very rare (the 1.92TB, much more common, can't replace a 2TB disk)

There are three grades of capacity that you can get:
1) ~1920 000 000 000 bytes
2) ~2000 000 000 000 bytes
3) ~2048 000 000 000 bytes

Nobody is marketing the 1st variant as "2TB", you will find "1920G" on the
packaging and datasheets instead.

2nd one should be able to replace an HDD, unless there's some smaller
discrepancy in the sizes near the 2 billion byte mark between HDDs and SSDs. A
reason to use smaller-than-whole-disk partitions for your RAID.

3rd is not a common sight in SATA SSDs (but still happens), and is nearly
universal in NVMe. Of about ten "2 TB" NVMe models I've tested, only one had
2000, *all* others were 2048. The 2000 one was Netac NV7000.

-- 
With respect,
Roman
