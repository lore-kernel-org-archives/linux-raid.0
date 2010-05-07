From: Joe Bryant <tenminjoe@yahoo.com>
Subject: Re: Spare drive won't spin down
Date: Fri, 7 May 2010 03:05:50 -0700 (PDT)
Message-ID: <68362.81946.qm@web31706.mail.mud.yahoo.com>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com> <20100507162034.1370d645@notabene.brown> <717013.48748.qm@web31703.mail.mud.yahoo.com> <20100507194704.3ffcf17e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100507194704.3ffcf17e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  mdadm /dev/md0 -f /dev/foo
>  mdadm /dev/md0 -r /dev/foo
>  mdadm /dev/md0 -a /dev/foo

> will switch between working and not working. 

It worked! Thanks so much.

 Joe Bryant


      
