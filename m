From: "Zhikun Wang" <raidwang@gmail.com>
Subject: why md request buffers will not across devices
Date: Wed, 18 Jan 2006 15:52:47 +0800
Message-ID: <200601181552442344275@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi,
	I have a silly question. Why md request buffers will not across devices? That means Why a bh will only locate in a single storage device? I guess maybe file system has aligned the bh? Who can tell me the exact reasons? Thanks a lot!


																						zkwang
 				


