From: Janek Kozicki <janek_listy@wp.pl>
Subject: deleting mdadm array?
Date: Thu, 25 Oct 2007 10:06:19 +0200
Message-ID: <20071025100619.3b3810be@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I just created a new array /dev/md1 like this:

mdadm --create --verbose /dev/md1 --chunk=64 --level=raid5 \
   --metadata=1.1  --bitmap=internal \
   --raid-devices=3 /dev/hdc2 /dev/sda2 missing


But later I changed my mind, and I wanted to use chunk 128. Do I need
to delete this array somehow first, or can I just create an array
again (overwriting the current one)?

-- 
Janek Kozicki                                                         |
