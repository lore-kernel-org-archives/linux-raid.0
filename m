From: Jack Wang <xjtuwjp@gmail.com>
Subject: [RFC] md raid resync counter
Date: Fri, 01 Nov 2013 13:59:40 +0100
Message-ID: <5273A5BC.5060109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil and all,

Is there anyway to know:

1. How often does a raid start to resync?
2. How many bytes did it resync?

If not, for the first one, I think we cound add field into mddev like
resync_counter, increase when resync done, and annother field into
md_rdev to track how many bytes synced to the outdated disk?

Regards,
Jack
