From: Omri Schwarz <ocschwar@MIT.EDU>
Subject: Re: Using the md driver to look at a bad hardware RAID.
Date: Thu, 03 Mar 2005 17:15:32 -0500
Message-ID: <200503032215.j23MFWZp016046@mint-square.mit.edu>
References: <200503020110.j221ASfj018044@bart-savagewood.mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_17224436560"
In-Reply-To: Your message of "Tue, 01 Mar 2005 20:10:28 EST."
             <200503020110.j221ASfj018044@bart-savagewood.mit.edu>
Sender: linux-raid-owner@vger.kernel.org
Cc: Mike Hardy <mhardy@h3c.com>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org, ocschwar@MIT.EDU
List-Id: linux-raid.ids

This is a multipart MIME message.

--==_Exmh_17224436560
Content-Type: text/plain; charset=us-ascii

So my dead drive has died further and will now read() nothing. 
It is an ex drive. Unable to do any manual XOR sanity checking, 
I can only read out the remaining drives, and pray that in the scratch 
space where they get copied to, I can find a partition that will 
make sense to the debugfs utility. 

Here's the C program I wrote to that end. Read the source
and make it suck less before you try to use it. 



--==_Exmh_17224436560
Content-Type: text/plain ; name="raidtest.c"; charset=us-ascii
Content-Description: raidtest.c
Content-Disposition: attachment; filename="raidtest.c"

#include <stdio.h>
#include <getopt.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>


/* --------------
A user-space RAID test facility for testing 
RAID 5 configurations.

*/
extern char *optarg;
extern int optind, opterr, optopt;
//extern int errno;

#define LEFT_SYMMETRIC 1
#define LEFT_ASYMMETRIC 1
long total_data=0; 
long chunk_size = 64; 
int verbose=0;
int ndevices=0; 
int parity_algorithm=LEFT_SYMMETRIC;
int write_out=0; 
int raid_level=5;
int bad_disk=-1;
int check_parity_p=1;
unsigned long  ** chunks;
FILE ** devices;
struct stat * devfs; 

void print_version(){
  fprintf(stdout,"RaidTest 0.0\n");
}
 void print_usage(){
  fprintf(stderr,"Usage: raidtest [-vpPhV] [-b NUMBER]"
	  " [-c CHUNKSIZE] [DEVICES]");
}

void stat_devices(char * devs[],int start,int stop){
  /* calls stat() on each device, complains if it cannot, 
     [vapor:or if device is not something that makes sense here] */
  int n; 
  struct stat devstat;
  for (n=start; n < stop; n++) {
    if (stat (devs[n],&devstat)==0){
      if (verbose) 
	fprintf(stderr,
		"%s stats ok.\n",
		devs[n]);
      if (verbose > 1){
	if (S_ISBLK(devstat.st_mode)){
	  fprintf(stderr,
		  "Block Device\n");
	}
      }
      if (S_ISDIR(devstat.st_mode)){
	fprintf(stderr,
		"%s is a directory. Confused. Exiting.\n",
		devs[n]);
	exit(-1);
      }
    } else { 
      fprintf(stderr,"Could not stat %s.\n",devs[n]);
      perror(NULL);
      exit(-1); 
    }
  }
  
}
unsigned long * parity; 

/* For a single row of data, this procedure 
   writes out what it holds. It skips the parity block,
   but uses it to reconstruct for a bad device what the 
   data must be.

   This may be wrappered around 
   to deal with any RAID 5 parity algorithms.

For Left symmetric, 
pdevice = ndevices - stripe_number % ndevices;

It's that simple. 
*/
int write_out_5_left_asymmetric(unsigned long ** buf,
		long cs,
		int ndevices,
		int pdevice, 
		int bad_device){
  int i;
  ssize_t r;

  /* use xor to recover data for bad_device */
  if ((bad_device > -1)&&(bad_device!=pdevice) ) {
    for (i=0;i<cs;i++) 
      buf[bad_device][i]=0l;

    for (i=0;i<ndevices;i++)
      if (i!= bad_device)
	for (i=0;i<cs;i++) 
	  buf[bad_device][i] ^= buf[pdevice][i];
  }

  for (i=0;i<ndevices;i++) {
    if (i!=pdevice) {
      r = fwrite(buf[i],
		 sizeof(long),
		 cs,
		 stdout);
      if (r<cs) {
	perror(	"Error dumping to stdout?\n");
	return -1;
      }
    }
  }
  return 0; 

}
int write_out_5_left_symmetric(unsigned long ** buf,
		long cs,
		int ndevices,
		int pdevice, 
		int bad_device){
  int i,n;
  ssize_t r;

  /* use xor to recover data for bad_device */
  if ((bad_device > -1)&&(bad_device!=pdevice) ) {
    for (i=0;i<cs;i++) 
      buf[bad_device][i]=0l;

    for (i=0;i<ndevices;i++)
      if (i!= bad_device)
	for (i=0;i<cs;i++) 
	  buf[bad_device][i] ^= buf[pdevice][i];
  }

  for (i=pdevice+1;i<ndevices+pdevice;i++) {
    if (i!=pdevice) {
      r = fwrite(buf[i%ndevices],
		 sizeof(long),
		 cs,
		 stdout);
      if (r<cs) {
	perror(	"Error dumping to stdout?\n");
	return -1;
      }
    }
  }
  return 0; 

}

/* 
 It really is this simple for RAID 4.
 Might as well include it. 
*/
int write_out_4_simple (unsigned long ** buf,
		long cs,
		int ndevices,
		int bad_device){

  return write_out_5_left_asymmetric(buf,
			    cs,
			    ndevices,
			    ndevices-1,
			    bad_device);

}

int check_parity_simple(unsigned long ** buf, unsigned long *pbuf){
  size_t i,c ; 

  /* reinitialize */
  //  memset ((long*)pbuf, 0, chunk_size*8); 
  for (c=0;c<chunk_size;c++)
     pbuf[c]=0;
  /* check parity */
  for (i=0;i<ndevices;i++) 
    for (c=0;c<chunk_size;c++)
      pbuf[c] ^= buf[i][c];

  for (c=0;c<chunk_size;c++)
    if (pbuf[c]>0)
      break;
  /* If the for loop broke, negative value.
     otherwise, 0. */
  return c - chunk_size  ; 
  
}

int read_devices (char * devs[],long offset) { 
  int i,n,cp ,y=1;
  long pos;
  size_t r;
  for (i=0 ; i<ndevices  ; i++){
    if ((devices[i]=fopen(devs[i+optind],"r"))==NULL){
      fprintf(stderr,"Could not open %s.\n",devs[i+optind]);
      perror(NULL);
      exit(-1);
    }
  }
  /* go to starting point */ 
  if (offset>0){
    for (i=0 ; i<ndevices  ; i++){
      if (fseek(devices[i],offset,SEEK_SET) <0){
	fprintf(stderr,"Error seek() %s to %ld.\n",devs[i+optind],offset);
	perror(NULL);
	exit(-1);
      }
    }
  }
  n=0;
  while (y) { 

    /* read each device */
    for (i=0 ; i<ndevices  ; i++){

      if (i==bad_disk)
	continue;
      if ((r=fread(chunks[i],
		   sizeof(long),
		   chunk_size,
		   devices[i]) )<
	  chunk_size){
	fprintf(stderr,
		"Could not do a whole read() on %s at %ld. Read only %d\n",
		devs[i+optind],
		ftell(devices[i]),
		r); 
	//	y=-1;
	r=fseek(devices[i],
		sizeof(long)*(chunk_size-r),
		SEEK_CUR);
	if (r<0)
	  fprintf(stderr,
		  "Could not do a skip on %s at %ld.\n",
		  devs[i+optind],
		  ftell(devices[i])); 

      }
    }
    /* get the parity checking done */ 
    if (check_parity_p){
      cp=check_parity_simple(chunks,parity); 
      if (cp<0)
	break;
    }
      /* spew out to stdout if wanted */
    if (write_out) {
      // Left Symmetric:      parity = ndevices-n%ndevices-1;
      write_out_5_left_symmetric(chunks,
				 chunk_size,
				 ndevices,
				 ndevices-n%ndevices-1,
				 bad_disk);
    }
    n++;
  }
  fprintf(stderr,
	  "Stopping after %d iterations. Parity broke at %d \n",
	  n,cp);
} 
/* return size of total data in kilobytes. */

long atosize(const char * a){
  char * l;
  long *s;
  if (strchr(a,'G'))
    return 1048576*atol(a); 
  if (strchr(a,'m'))
    return 1024*atol(a); 
  return atol(a);

}

int main(int argc, char *argv[]) {
  int c,oi;
  struct option long_options[] =
    {
      {"verbose",0,0,'v'},
      {"parity",0,0,'P'},
      {"noparity",0,0,'p'},
      {"bad",1,0,'b'},
      {"writeout",0,0,'w'},
      {"chunksize",1,0,'c'},
      {"version",0,0,'V'},
      {"help",0,0,'h'},
      {"usage",0,0,'h'},
      {0,0,0,0}
    };
  while(1){
    c= getopt_long (argc, argv,"hpPvVwb:c:",
                    long_options, &oi);
    if (c == -1)
      break ;
 
    switch(c) {
    case 'c':
      chunk_size=atol(optarg);
      break;
    case 't':
      total_data=atosize(optarg);
      break;
    case 'b':
      bad_disk=atoi(optarg);
      break;
    case 'h':
      print_usage();
      exit(0);
      break;
    case 'P':
      check_parity_p=1;
      break;
    case 'p':
      check_parity_p=0;
      break;
    case 'V':
      print_version();
      exit(0);
    case 'v':
      verbose++;
      break;
    case 'w':
      write_out++;
      break;
    default:
      print_usage();
      fprintf(stderr,"Unrecognized flag %s. Exiting.\n",optarg);
      exit(-1);
      break;
    }
  }
  /* argc and optind should know how many devices we have*/

  ndevices = argc-optind; 

  if (!ndevices){
    fprintf(stderr,"No Devices Listed.\n");
    exit(-1);
  }

  if (verbose>2){
    for (c=optind;c<argc;c++)
      fprintf(stderr,
	      "%s ",
	      argv[c]); 
    fprintf(stderr,
	    "argc %d optind %d ndevices %d\n",
	    argc,
	    optind,
	    ndevices);
    
  }
  /* chunk_size is entered in k's.
     But we're doing things in long. 1 k is 128 longs */
  /* This would be 256 if we used 32 bit operations. */

  chunk_size *= 128;

  /* allocate file handles and memory */
  /* first the ludicrous task of allocating ndevices worth of pointers. */
  if (!(chunks = (unsigned long**)malloc((size_t)ndevices*
					 sizeof(unsigned long*)))){
    fprintf(stderr,"Could not allocate memory for chunk buffer.\n");
    exit(-1);
  }
  /* now a chunk for each device, in one place */
  if (!(chunks[0] =
	(unsigned long*)malloc(ndevices*chunk_size*sizeof(long)))){
    fprintf(stderr,"Could not allocate memory for chunk buffer.\n");
    exit(-1);
  }
  /* spreading the love. */
  for (c=1;c<ndevices;c++){
    chunks[c]=chunks[c-1]+chunk_size;
  }
  if (!(devices = (FILE**)malloc((size_t)ndevices* sizeof(FILE*)))){
    fprintf(stderr,"Could not allocate memory for FILE objects\n");
    exit(-1);
  }
  if (!(parity =
	(unsigned long*)malloc(chunk_size*sizeof(long)))){
    fprintf(stderr,"Could not allocate memory for parity buffer.\n");
    exit(-1);
  }

  if (verbose){
    fprintf(stderr,"Stat()ing devices.\n"); 
  }
  stat_devices(argv,optind,argc);
  if (verbose){
    fprintf(stderr,"Scanning devices.\n"); 
  }
  read_devices(argv,0);
}   


--==_Exmh_17224436560--


