db = db.getSiblingDB('exercise-2');
db.createUser({
  user: 'bookuser',
  pwd: 'bookpass',
  roles: [
    {
      role: 'readWrite',
      db: 'exercise-2',
    },
  ],
});
