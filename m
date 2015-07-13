From: Steven Reddie <steven.reddie@gmail.com>
Subject: mdadm --create parameter ordering
Date: Mon, 13 Jul 2015 20:26:48 +1000
Message-ID: <CAFcup8E3iKxb8H-Fz76bKJQhjmhq1FuVu11rEPb-k=g2U_nX=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Given the following command:

    mdadm -Cf /dev/md3 -e1.2 -n5 -l6 /dev/sdga5 /dev/sdgb5 /dev/sdgc5
/dev/sdgd5 /dev/sdge5 -u<uuid>

Is the order that the disks are specified on the command-line significant?

Somebody suggested this command to put the disks back in the correct
order (though I believe he was mistaken about the correct order). It
seems to me that if the order on the command-line is significant that
this would have caused parity to get recalculated (based on the
[incorrect] order of the disks) and the new parity to be written over
actual data blocks. I see no evidence that this has occurred, which
leads me to believe that the actual ordering within the array is
detected and everything proceeds as it should, in which case issuing
the command above likely was a very time-consuming no-op.

Also, it seems that I should be able to issue such a command without
the full scan of the disks. Is that what the "--run" option is for? If
so, does "--readonly" protect me from harm that improper use of
"--run" may cause?

Thanks,

Steven
