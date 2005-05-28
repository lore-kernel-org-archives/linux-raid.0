From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: cpu
Date: Sun, 29 May 2005 00:25:20 +0200
Message-ID: <5d96567b05052815251f1cd297@mail.gmail.com>
Reply-To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was testing linux raid for sometime, I created several test units
which send read request to the raid using big buffers( 4MB).
It seems to be that the software raid consumes to much cpu. I reach
100% cpu usage just by reading from the raid.
I used 4 disks raid 0.

-- 
Raz
Long Live the Penguin
