From: Paul Waldo <pwaldo@waldoware.com>
Subject: Care and feeding of RAID?
Date: Tue, 05 Sep 2006 08:48:44 -0400
Message-ID: <44FD722C.7050608@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a RAID6 array and I wondering about care and feeding instructions :-)

Here is what I currently do:
    - daily incremental and weekly full backups to a separate machine
    - run smartd tests (short once a day, long once a week)
    - check the raid for bad blocks every week

What else can I do make sure the array keeps humming?  Thanks in advance!
