From: dong wu <dongwucs@gmail.com>
Subject: when read error ,where do we rewrite?
Date: Thu, 7 Jan 2010 20:41:20 +0800
Message-ID: <6c394cc31001070441r1287f635q9c58dc836ce488b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

when read error and can rewrite,where do we rewrite?
It can't be rewrited to the old block.
It should be rewrite to other place,where can we find the 'other place'?
In the source code,I don't find the place that should be rewrited to.



Dong Wu
