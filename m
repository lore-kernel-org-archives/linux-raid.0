From: "=?GB2312?B?uPDQ29fK?=" <xiongzige@gmail.com>
Subject: Call for help of raid5
Date: Thu, 15 Jun 2006 10:44:42 +0800
Message-ID: <1caa67950606141944n7eb794eejc2be08e162d81d75@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In the make_request() function,
 prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
how does the system wake up the (&conf->wait_for_overlap) For the first time?
And how does the first request deliver to the device driver. ?
