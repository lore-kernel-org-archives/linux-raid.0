From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Storage device enumeration script
Date: Thu, 26 May 2011 01:14:12 -0500
Message-ID: <7D.22.00666.3BFEDDD4@cdptpa-omtalb.mail.rr.com>
References: <4DDDC301.7090608@turmel.org>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDDC301.7090608@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	I get an error right off the bat:

Traceback (most recent call last):
  File "./lsdrv.txt", line 264, in <module>
    for x in runx(['pvs', '-o',
'pv_name,pv_used,pv_size,pv_uuid,vg_name,vg_size,vg_free,vg_uuid',
'--noheadings', '--separator', ' ']).split("\n"):
  File "./lsdrv.txt", line 50, in runx
    sub = Popen(*args, **kwargs)
  File "/usr/lib/python2.6/subprocess.py", line 623, in __init__
    errread, errwrite)
  File "/usr/lib/python2.6/subprocess.py", line 1141, in _execute_child
    raise child_exception
OSError: [Errno 2] No such file or directory

I'm running Python 2.6.6 and mdadm 3.1.4 running on kernel 2.6.32-5-amd64


