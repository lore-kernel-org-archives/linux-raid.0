From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: mdadm -C / 0.90?
Date: Mon, 17 Apr 2006 16:10:31 +0200
Message-ID: <62b0912f0604170710i5941449bycbdb0fd13acaf950@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, list

You wrote:
>   mdadm -C /dev/md1 --assume-clean /dev/sd{a,b,c,d,e,f}1

Will the above destroy data by overwriting the on-disk v0.9 superblock
with a larger v1 superblock?

--assume-clean is not document in 'mdadm --create --help', by the way
- what does it do?
