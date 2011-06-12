From: jeffs_linux@123mail.org
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Sat, 11 Jun 2011 18:49:26 -0700
Message-ID: <1307843366.27897.1462148437@webmail.messagingengine.com>
References: <1307840471.18429.1462140465@webmail.messagingengine.com>
 <1307842966.26762.1462147225@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307842966.26762.1462147225@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

and, one more bit of information

ls -al /dev/md*
brw-rw---- 1 root disk 9, 126 Jun 11 16:52 /dev/md126
brw-rw---- 1 root disk 9, 127 Jun 11 16:51 /dev/md127

/dev/md:
total 0
drwxr-xr-x  2 root root   60 Jun 11 16:52 ./
drwxr-xr-x 22 root root 5560 Jun 11 17:15 ../
lrwxrwxrwx  1 root root    8 Jun 11 16:52 0_0 -> ../md126

Jeff
