From: "Theepan" <tornado@linuxfromscratch.org>
Subject: Re: Which (physical) disk is broken?
Date: Fri, 24 Dec 2004 12:31:34 +0100
Message-ID: <004e01c4e9ac$1fd7a750$0200a8c0@tornado>
References: <200412221639.iBMGdH911479@www.watkins-home.com><874qie3qvy.fsf@pumba.bayour.com><16841.64683.581049.327577@cse.unsw.edu.au> <874qic2brg.fsf@pumba.bayour.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> I was more thinking on the 'magic'. When I created the array, I included
> this broken disk. I later removed it, but there should still (?) be a
> record of it in the super block (or wherever mdadm checks).
>
> It knows how many disks there SHOULD be, and it knows how many is working.
>

How about something primitive as checking the syslog messages (sent to
facility kern)? You'll get messages from 'md' when you manipulate arrays, at
least this is true for kernel 2.4. You'll see something like this:

Dec 24 12:25:02 storm kernel: md: trying to remove hdk1 from md4 ...

--
Theepan


