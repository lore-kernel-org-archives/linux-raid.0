From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 performance question
Date: Mon, 6 Mar 2006 17:17:16 -0500
Message-ID: <200603062217.k26MHLp05891@www.watkins-home.com>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Raz Ben-Jehuda(caro)'" <raziebe@gmail.com>, 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
Cc: 'Neil Brown' <neilb@suse.de>
List-Id: linux-raid.ids

Does test 1 have 4 processes?
Does test 2 have 1 process?

The number of testing processes should be the same in both tests.

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Raz Ben-Jehuda(caro)
} Sent: Monday, March 06, 2006 6:46 AM
} To: Linux RAID Mailing List
} Cc: Neil Brown
} Subject: raid5 performance question
} 
} Neil Hello .
} I have a performance question.
} 
} I am using raid5 stripe size 1024K over 4 disks.
} I am benchmarking it with an asynchronous tester.
} This tester submits 100 IOs of size of 1024 K --> as the stripe size.
} It reads raw io from the device, no file system is involved.
} 
} I am making the following comparsion:
} 
} 1. Reading 4 disks at the same time using 1 MB buffer in random manner.
} 2. Reading 1 raid5 device using 1MB buffer in random manner.
} 
} I am getting terrible results in scenario 2. if scenario 1 gives 120 MB/s
} from
} 4 disks, the raid5 device gives 35 MB/s .
} it is like i am reading a single disk , but by looking at iostat i can
} see that all
} disks are active but with low throughput.
} 
} Any idea ?
} 
} Thank you.
} --
} Raz
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

