From: Ofer Heifetz <oferh@marvell.com>
Subject: raid5 using group_thread
Date: Wed, 19 Jul 2017 13:00:45 +0000
Message-ID: <721dda9c0d5f4df0838a7365a53e8e04@IL-EXCH01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have a question regarding raid5 built using group_thread and async_tx, from code (v4.4 and even v4.12) I see that only raid5d invokes async_tx_issue_pending_all, shouldn't the raid5_do_work also invoke this API to issue
all pending requests to HW?

I am assuming that there is no sync mechanism between the raid5d and the raid5_do_work, correct me if I am wrong.

Thanks,

/Ofer
