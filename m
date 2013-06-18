From: =?UTF-8?B?0KDQvtC80LDQvSDQkNC70LXQutGB0LXQtdCy?=
	<r.alekseev@qwarta.ru>
Subject: Optimal value for bitmap-chunk option
Date: Tue, 18 Jun 2013 16:52:09 +0400
Message-ID: <51C057F9.3020005@qwarta.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I want to speed up rebuilding process of the raid to do that I'm going
to apply the command:

mdadm --grow --bitmap=internal --bitmap-chunk=NNNN /dev/mdX

But I don't know how to calculate optimal value of bitmap-chunk option.
How can I do that?

Any help would be greatly appreciated.

--
Roman
