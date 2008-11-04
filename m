From: Gregory Stark <stark@enterprisedb.com>
Subject: md has hard coded maximum number of drives?
Date: Tue, 04 Nov 2008 21:21:25 +0000
Message-ID: <87wsfj5gru.fsf@oxford.xeocode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Ah, nevermind. I just discovered that mdadm defaults to the old 0.90 format
superblock. I suppose that's still a WTF but at least it makes sense.

Perhaps the error message should explain exactly *why* 28+ is invalid and
suggest using -e to work around the problem.

-- 
greg
