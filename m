From: Tru Huynh <tru@pasteur.fr>
Subject: Re: Problems with software raid - all mine I am sure
Date: Tue, 27 Feb 2007 12:38:19 +0100
Message-ID: <20070227113819.GH19607@sillage.bis.pasteur.fr>
References: <45E31D6A.4040805@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45E31D6A.4040805@kmaclub.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael <michael@kmaclub.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 26, 2007 at 10:48:26AM -0700, Michael wrote:
> Hello,
>
... 
<mix knoppix and fc6 >

Why don't you do everything from the text/gui installation of fc6
instead of swapping distributions?

You can do everything you have said within the fc6 installer:
http://fedora.redhat.com/docs/install-guide/fc6/en/sn-disk-druid.html
boot in raid1 on sda1/sdb1
swap,/ and /export as raid5 on sd{abcd}{234}
...

you don't have to use LVM.

my .2 cents

Tru
