From: d4lamar <d4lamar@gmail.com>
Subject: Stop resync operation
Date: Fri, 6 Nov 2015 07:44:16 +0100
Message-ID: <CAF8SPVLYv4fq1Wf80RGHuiO0bLwCK7EU+yp3M3bBXk2_23Nf4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Developers,

I have a question for you.

I have a raid10 md array:

Is it theoretically possible to stop a running resync operation and
mark the array as clean without stopping the array ?

I do not want the resync to be respawned automatically.

Thanks and Best Regards,
d4lamar
