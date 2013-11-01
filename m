From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?cmFpZDUgcmFpZDVkICBtdWx0aS10aHJlYWQ=?=
Date: Fri, 01 Nov 2013 11:27:12 +0800
Message-ID: <72a920d2-2c76-41af-bcac-0dee5b36df5a@aliyun.com>
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

now in MD raid5,stripe is hande in one thread, and I found the CPU occupation is very high, why stripe is not handled in multi-thread ? is any different to implement? and what consideration in original design?


