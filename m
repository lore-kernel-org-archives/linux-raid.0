From: Christoph Hellwig <hch@lst.de>
Subject: decruft the early init / initrd / initramfs code
Date: Mon, 15 Jun 2020 14:53:07 +0200
Message-ID: <20200615125323.930983-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

this series starts to move the early init code away from requiring
KERNEL_DS to be implicitly set during early startup.  It does so by
first removing legacy unused cruft, and the switches away the code
from struct file based APIs to our more usual in-kernel APIs.
