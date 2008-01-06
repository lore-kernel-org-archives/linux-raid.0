From: Hxsrmeng <hxsrmeng@gmail.com>
Subject: Why "mdadm --monitor --program" sometimes only gives 2 command-line
 arguments to the program?
Date: Sat, 5 Jan 2008 18:11:38 -0800 (PST)
Message-ID: <14642331.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,

I need to monitor my RAID and if it fails, I'd like to call my-script to
deal with the failure.

I did: 
mdadm --monitor --program my-script --delay 60 /dev/md1

And then, I simulate a failure with
mdadm --manage --set-faulty /dev/md1 /dev/sda2
mdadm /dev/md1 --remove /dev/sda2

I hope the mdadm monitor function can pass all three command-line
arguments to my-script, including the name of the event, the name of the
md device and the name of a related device if relevant.

But my-script doesn't get the third one, which should be /dev/sda2. Is
this not "relevant"?

If I really need to know it's /dev/sda2 that fails, what can I do?

Thanks.


-- 
View this message in context: http://www.nabble.com/Why-%22mdadm---monitor---program%22-sometimes-only-gives-2-command-line-arguments-to-the-program--tp14642331p14642331.html
Sent from the linux-raid mailing list archive at Nabble.com.

