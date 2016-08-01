From: Xiao Ni <xni@redhat.com>
Subject: One question about raid10 resync
Date: Mon, 1 Aug 2016 10:02:05 -0400 (EDT)
Message-ID: <883771019.9607776.1470060125662.JavaMail.zimbra@redhat.com>
References: <1870990013.9606108.1470059688027.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1870990013.9606108.1470059688027.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

Hi all

I have a question about raid10 resync. The fbio->bi_next isn't null in function
sync_request_write. But the bios' bi_next that read the data from copies is set 
to NULL before sending down to underlying devices in raid10_sync_request. 

I tried to find where links those bios that don't belong to a r10_bio. But I can't
find it. Is it a bug?

Best Regards
Xiao
